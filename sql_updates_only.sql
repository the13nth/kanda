-- SQL Updates Only - No Conflicts
-- Run this in your Supabase SQL editor

-- 1. Create vehicles table (only if it doesn't exist)
CREATE TABLE IF NOT EXISTS public.vehicles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    make TEXT NOT NULL,
    model TEXT NOT NULL,
    year INTEGER NOT NULL,
    color TEXT NOT NULL,
    license_plate TEXT NOT NULL,
    vin TEXT NOT NULL,
    engine_type TEXT NOT NULL,
    mileage INTEGER NOT NULL,
    usage TEXT NOT NULL CHECK (usage IN ('personal', 'commercial', 'ride_share')),
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Add new columns to existing policies table
ALTER TABLE public.policies 
ADD COLUMN IF NOT EXISTS vehicle_id UUID REFERENCES public.vehicles(id) ON DELETE SET NULL,
ADD COLUMN IF NOT EXISTS coverage_level TEXT CHECK (coverage_level IN ('basic', 'standard', 'premium')),
ADD COLUMN IF NOT EXISTS monthly_premium DECIMAL(10,2),
ADD COLUMN IF NOT EXISTS annual_premium DECIMAL(10,2),
ADD COLUMN IF NOT EXISTS risk_level TEXT CHECK (risk_level IN ('low', 'moderate', 'high')),
ADD COLUMN IF NOT EXISTS coverage_details JSONB,
ADD COLUMN IF NOT EXISTS discount DECIMAL(5,2),
ADD COLUMN IF NOT EXISTS discount_reason TEXT,
ADD COLUMN IF NOT EXISTS description TEXT;

-- 3. Update existing policy_type constraint to include new types
ALTER TABLE public.policies 
DROP CONSTRAINT IF EXISTS policies_policy_type_check;

ALTER TABLE public.policies 
ADD CONSTRAINT policies_policy_type_check 
CHECK (policy_type IN ('comprehensive', 'third_party', 'collision', 'health', 'home', 'life', 'travel'));

-- 4. Update existing status constraint to include new statuses
ALTER TABLE public.policies 
DROP CONSTRAINT IF EXISTS policies_status_check;

ALTER TABLE public.policies 
ADD CONSTRAINT policies_status_check 
CHECK (status IN ('active', 'inactive', 'pending', 'expired', 'cancelled'));

-- 5. Enable RLS on vehicles table
ALTER TABLE public.vehicles ENABLE ROW LEVEL SECURITY;

-- 6. Create RLS policies for vehicles (only if they don't exist)
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'vehicles' AND policyname = 'Users can view own vehicles'
    ) THEN
        CREATE POLICY "Users can view own vehicles" ON public.vehicles
            FOR SELECT USING (auth.uid() = user_id);
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'vehicles' AND policyname = 'Users can insert own vehicles'
    ) THEN
        CREATE POLICY "Users can insert own vehicles" ON public.vehicles
            FOR INSERT WITH CHECK (auth.uid() = user_id);
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'vehicles' AND policyname = 'Users can update own vehicles'
    ) THEN
        CREATE POLICY "Users can update own vehicles" ON public.vehicles
            FOR UPDATE USING (auth.uid() = user_id);
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'vehicles' AND policyname = 'Users can delete own vehicles'
    ) THEN
        CREATE POLICY "Users can delete own vehicles" ON public.vehicles
            FOR DELETE USING (auth.uid() = user_id);
    END IF;
END $$;

-- 7. Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_vehicles_user_id ON public.vehicles(user_id);
CREATE INDEX IF NOT EXISTS idx_vehicles_license_plate ON public.vehicles(license_plate);
CREATE INDEX IF NOT EXISTS idx_policies_vehicle_id ON public.policies(vehicle_id);
CREATE INDEX IF NOT EXISTS idx_policies_status ON public.policies(status);

-- 8. Create updated_at trigger for vehicles table (only if it doesn't exist)
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger 
        WHERE tgname = 'handle_updated_at_vehicles'
    ) THEN
        CREATE TRIGGER handle_updated_at_vehicles
            BEFORE UPDATE ON public.vehicles
            FOR EACH ROW
            EXECUTE FUNCTION public.handle_updated_at();
    END IF;
END $$;

-- 9. Update existing policies to have default values for new columns
UPDATE public.policies 
SET 
    coverage_level = 'standard',
    monthly_premium = premium_amount,
    annual_premium = premium_amount * 12,
    risk_level = 'moderate'
WHERE coverage_level IS NULL;

-- 10. Set policy_number to auto-generate with default format
ALTER TABLE public.policies 
ALTER COLUMN policy_number SET DEFAULT 'POL-' || to_char(now(), 'YYYYMMDD') || '-' || substr(md5(random()::text), 1, 6);

-- 10.1. Set default insurance company for existing policies
UPDATE public.policies 
SET insurance_company = 'Default Insurance Co.'
WHERE insurance_company IS NULL;

-- 10.2. Set default insurance company for new policies
ALTER TABLE public.policies 
ALTER COLUMN insurance_company SET DEFAULT 'Default Insurance Co.';

-- 11. Make new required columns NOT NULL after setting defaults
ALTER TABLE public.policies 
ALTER COLUMN coverage_level SET NOT NULL,
ALTER COLUMN monthly_premium SET NOT NULL,
ALTER COLUMN annual_premium SET NOT NULL,
ALTER COLUMN risk_level SET NOT NULL;

-- 12. Create claims table
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

-- 13. Enable RLS on claims table
ALTER TABLE public.claims ENABLE ROW LEVEL SECURITY;

-- 14. Create RLS policies for claims
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

-- 15. Create updated_at trigger for claims table
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

-- 16. Create indexes for claims table
CREATE INDEX IF NOT EXISTS idx_claims_user_id ON public.claims(user_id);
CREATE INDEX IF NOT EXISTS idx_claims_policy_id ON public.claims(policy_id);
CREATE INDEX IF NOT EXISTS idx_claims_status ON public.claims(status);
CREATE INDEX IF NOT EXISTS idx_claims_created_at ON public.claims(created_at);
