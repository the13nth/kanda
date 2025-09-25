-- Update Database Schema - Add Vehicles and Update Policies
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
ADD COLUMN IF NOT EXISTS discount_reason TEXT;

-- 3. Make policy_number auto-generate if not provided
ALTER TABLE public.policies 
ALTER COLUMN policy_number SET DEFAULT 'POL-' || substr(gen_random_uuid()::text, 1, 8);

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

-- 8. Create updated_at trigger for vehicles table
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER handle_updated_at_vehicles
    BEFORE UPDATE ON public.vehicles
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

-- 9. Update existing policies to have default values for new columns
UPDATE public.policies 
SET 
    coverage_level = 'standard',
    monthly_premium = premium_amount,
    annual_premium = premium_amount * 12,
    risk_level = 'moderate'
WHERE coverage_level IS NULL;

-- 10. Make new required columns NOT NULL after setting defaults
ALTER TABLE public.policies 
ALTER COLUMN coverage_level SET NOT NULL,
ALTER COLUMN monthly_premium SET NOT NULL,
ALTER COLUMN annual_premium SET NOT NULL,
ALTER COLUMN risk_level SET NOT NULL;
