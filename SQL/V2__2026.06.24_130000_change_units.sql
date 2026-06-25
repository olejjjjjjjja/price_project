

-- 1. СОЗДАНИЕ ТАБЛИЦЫ, ЕСЛИ ЕЁ НЕТ
CREATE TABLE IF NOT EXISTS edinica_izmerenia (
    id          INTEGER PRIMARY KEY,
    naimenovanie VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO edinica_izmerenia (id, naimenovanie)
SELECT DISTINCT 
    ROW_NUMBER() OVER (ORDER BY ed_izmerenia) AS id,
    ed_izmerenia
FROM tovar
WHERE ed_izmerenia IS NOT NULL AND ed_izmerenia != ''
ON CONFLICT (naimenovanie) DO NOTHING;


DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name='tovar' AND column_name='edinica_id') THEN
        ALTER TABLE tovar ADD COLUMN edinica_id INTEGER REFERENCES edinica_izmerenia(id);
    END IF;
END $$;

UPDATE tovar 
SET edinica_id = ei.id
FROM edinica_izmerenia ei
WHERE tovar.ed_izmerenia = ei.naimenovanie
  AND tovar.edinica_id IS NULL;


ALTER TABLE tovar DROP COLUMN IF EXISTS ed_izmerenia;

