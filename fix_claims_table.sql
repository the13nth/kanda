-- Fix Claims Table - Run this in your Supabase SQL editor
-- This will create the claims table if it doesn't exist

-- Create claims table
CREATE TABLE IF NOT EXISTS public.claims (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    policy_id UUID REFERENCES public.policies(id) ON DELETE SET NULL,
    claim_type TEXT NOT NULL CHECK (claim_type IN ('accident', 'theft', 'damage', 'other')),
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'processing')),
    incident_date DATE NOT NULL,
    incident_location TEXT NOT NULL,
    description TEXT NOT NULL,
    estimated_amount DECIMAL(10,2),
    police_report_number TEXT,
    witness_contact TEXT,
    attachments TEXT[],
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS on claims table
ALTER TABLE public.claims ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for claims
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'claims' AND policyname = 'Users can view own claims'
    ) THEN
        CREATE POLICY "Users can view own claims" ON public.claims
            FOR SELECT USING (auth.uid() = user_id);
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'claims' AND policyname = 'Users can insert own claims'
    ) THEN
        CREATE POLICY "Users can insert own claims" ON public.claims
            FOR INSERT WITH CHECK (auth.uid() = user_id);
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'claims' AND policyname = 'Users can update own claims'
    ) THEN
        CREATE POLICY "Users can update own claims" ON public.claims
            FOR UPDATE USING (auth.uid() = user_id);
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'claims' AND policyname = 'Users can delete own claims'
    ) THEN
        CREATE POLICY "Users can delete own claims" ON public.claims
            FOR DELETE USING (auth.uid() = user_id);
    END IF;
END $$;

-- Create updated_at trigger for claims table
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger 
        WHERE tgname = 'handle_updated_at_claims'
    ) THEN
        CREATE TRIGGER handle_updated_at_claims
            BEFORE UPDATE ON public.claims
            FOR EACH ROW
            EXECUTE FUNCTION public.handle_updated_at();
    END IF;
END $$;

-- Create indexes for claims table
CREATE INDEX IF NOT EXISTS idx_claims_user_id ON public.claims(user_id);
CREATE INDEX IF NOT EXISTS idx_claims_policy_id ON public.claims(policy_id);
CREATE INDEX IF NOT EXISTS idx_claims_status ON public.claims(status);
CREATE INDEX IF NOT EXISTS idx_claims_created_at ON public.claims(created_at);
