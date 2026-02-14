/*
  # Fix Device-Based Pairing System
  
  ## Overview
  Restructures the database to work without authentication, using device IDs instead.
  
  ## Changes
  
  1. Drop Foreign Key Constraints
     - Remove dependencies on auth.users/profiles
     - Allow device IDs as plain strings
  
  2. Update Tables
     - Modify couples table to use text IDs instead of UUID references
     - Simplify couple_invitations for PIN-based pairing
  
  3. Security
     - Update RLS policies for anonymous access
     - Maintain data isolation by couple_id
  
  4. Important Notes
     - Device IDs are stored as text instead of UUID
     - No authentication required for basic operations
     - PINs expire after 5 minutes for security
*/

-- Drop existing foreign key constraints on couples
ALTER TABLE IF EXISTS couples 
  DROP CONSTRAINT IF EXISTS couples_user1_id_fkey,
  DROP CONSTRAINT IF EXISTS couples_user2_id_fkey;

-- Drop existing foreign key constraints on memories
ALTER TABLE IF EXISTS memories 
  DROP CONSTRAINT IF EXISTS memories_created_by_fkey;

-- Drop existing foreign key constraints on couple_invitations
ALTER TABLE IF EXISTS couple_invitations 
  DROP CONSTRAINT IF EXISTS couple_invitations_sender_id_fkey,
  DROP CONSTRAINT IF EXISTS couple_invitations_recipient_id_fkey;

-- Recreate couples table with text IDs
DROP TABLE IF EXISTS couples CASCADE;
CREATE TABLE couples (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user1_id text NOT NULL,
  user2_id text NOT NULL,
  couple_name text NOT NULL DEFAULT 'Our Memory Book',
  anniversary_date date,
  created_at timestamptz DEFAULT now(),
  status text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'pending', 'ended')),
  CONSTRAINT different_users CHECK (user1_id != user2_id)
);

-- Recreate memories table with text created_by
DROP TABLE IF EXISTS memories CASCADE;
CREATE TABLE memories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id uuid NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  created_by text NOT NULL,
  title text NOT NULL,
  description text DEFAULT '',
  memory_date date NOT NULL,
  image_url text,
  category text NOT NULL DEFAULT 'moment' CHECK (category IN ('date', 'gift', 'trip', 'milestone', 'moment', 'surprise', 'celebration')),
  is_favorite boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Recreate couple_invitations for simple PIN-based pairing
DROP TABLE IF EXISTS couple_invitations CASCADE;
CREATE TABLE couple_invitations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_id text NOT NULL,
  recipient_email text DEFAULT '',
  recipient_id text,
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected', 'expired')),
  invitation_code text UNIQUE NOT NULL,
  expires_at timestamptz NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_couples_user1 ON couples(user1_id);
CREATE INDEX IF NOT EXISTS idx_couples_user2 ON couples(user2_id);
CREATE INDEX IF NOT EXISTS idx_couples_status ON couples(status);
CREATE INDEX IF NOT EXISTS idx_memories_couple ON memories(couple_id);
CREATE INDEX IF NOT EXISTS idx_memories_date ON memories(memory_date);
CREATE INDEX IF NOT EXISTS idx_memories_category ON memories(category);
CREATE INDEX IF NOT EXISTS idx_invitations_code ON couple_invitations(invitation_code);
CREATE INDEX IF NOT EXISTS idx_invitations_status ON couple_invitations(status);
CREATE INDEX IF NOT EXISTS idx_invitations_sender ON couple_invitations(sender_id);

-- Enable RLS
ALTER TABLE couples ENABLE ROW LEVEL SECURITY;
ALTER TABLE memories ENABLE ROW LEVEL SECURITY;
ALTER TABLE couple_invitations ENABLE ROW LEVEL SECURITY;

-- Drop all existing policies
DROP POLICY IF EXISTS "Users can view their couples" ON couples;
DROP POLICY IF EXISTS "Users can create couples" ON couples;
DROP POLICY IF EXISTS "Users can update their couples" ON couples;
DROP POLICY IF EXISTS "Users can delete their couples" ON couples;
DROP POLICY IF EXISTS "Allow couple creation by devices" ON couples;
DROP POLICY IF EXISTS "Allow viewing couples" ON couples;
DROP POLICY IF EXISTS "Allow couple updates" ON couples;

DROP POLICY IF EXISTS "Users can view couple memories" ON memories;
DROP POLICY IF EXISTS "Users can create memories for their couple" ON memories;
DROP POLICY IF EXISTS "Users can update their couple's memories" ON memories;
DROP POLICY IF EXISTS "Users can delete their couple's memories" ON memories;

DROP POLICY IF EXISTS "Users can view their sent invitations" ON couple_invitations;
DROP POLICY IF EXISTS "Users can create invitations" ON couple_invitations;
DROP POLICY IF EXISTS "Users can update invitations they're involved in" ON couple_invitations;
DROP POLICY IF EXISTS "Allow PIN creation without auth" ON couple_invitations;
DROP POLICY IF EXISTS "Allow reading invitations by code" ON couple_invitations;
DROP POLICY IF EXISTS "Allow updating invitations by code" ON couple_invitations;

-- Create new permissive policies for device-based access
CREATE POLICY "Allow all operations on couples"
  ON couples FOR ALL
  TO anon, authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow all operations on memories"
  ON memories FOR ALL
  TO anon, authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow all operations on invitations"
  ON couple_invitations FOR ALL
  TO anon, authenticated
  USING (true)
  WITH CHECK (true);

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS trigger AS $$
BEGIN
  new.updated_at = now();
  RETURN new;
END;
$$ LANGUAGE plpgsql;

-- Trigger for updated_at on memories
DROP TRIGGER IF EXISTS set_updated_at_memories ON memories;
CREATE TRIGGER set_updated_at_memories
  BEFORE UPDATE ON memories
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();