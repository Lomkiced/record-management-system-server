/**
 * Script to insert sub-offices under ORD for Ilocos Region
 * Run with: node insertSubOffices.js
 */
const pool = require('./config/db');

async function insertSubOffices() {
    try {
        // First, find the ORD office_id for Ilocos Region (region_id = 6)
        const ordResult = await pool.query(
            `SELECT office_id FROM offices WHERE code = 'ORD' AND region_id = 6`
        );

        let ordId;
        if (ordResult.rows.length === 0) {
            console.log('ORD office not found for Ilocos Region. Creating it first...');
            const insertOrd = await pool.query(
                `INSERT INTO offices (name, code, region_id, status) 
         VALUES ('Office of the Regional Director', 'ORD', 6, 'Active')
         RETURNING office_id`
            );
            ordId = insertOrd.rows[0].office_id;
            console.log('Created ORD with office_id:', ordId);
        } else {
            ordId = ordResult.rows[0].office_id;
            console.log('Found ORD with office_id:', ordId);
        }

        // Define sub-offices to create under ORD
        const subOffices = [
            { name: 'Information Technology and Systems Management', code: 'ITSM' },
            { name: 'Administrative Division', code: 'AD' },
            { name: 'Finance Division', code: 'FD' },
            { name: 'Planning and Monitoring Division', code: 'PMD' },
            { name: 'Technical Operations Division', code: 'TOD' }
        ];

        console.log('\nInserting sub-offices under ORD...');

        for (const sub of subOffices) {
            // Check if already exists
            const exists = await pool.query(
                `SELECT office_id FROM offices WHERE code = $1 AND parent_id = $2`,
                [sub.code, ordId]
            );

            if (exists.rows.length > 0) {
                console.log(`  - ${sub.code} already exists, skipping`);
                continue;
            }

            await pool.query(
                `INSERT INTO offices (name, code, region_id, parent_id, status)
         VALUES ($1, $2, 6, $3, 'Active')`,
                [sub.name, sub.code, ordId]
            );
            console.log(`  ✓ Created ${sub.code}: ${sub.name}`);
        }

        // Also create top-level offices FOS, FAS, TOS if they don't exist
        const topLevelOffices = [
            { name: 'Field Operations Services', code: 'FOS' },
            { name: 'Finance and Administrative Services', code: 'FAS' },
            { name: 'Technical Operations Services', code: 'TOS' }
        ];

        console.log('\nEnsuring top-level offices exist for Ilocos Region...');

        for (const office of topLevelOffices) {
            const exists = await pool.query(
                `SELECT office_id FROM offices WHERE code = $1 AND region_id = 6 AND parent_id IS NULL`,
                [office.code]
            );

            if (exists.rows.length > 0) {
                console.log(`  - ${office.code} already exists`);
                continue;
            }

            await pool.query(
                `INSERT INTO offices (name, code, region_id, status)
         VALUES ($1, $2, 6, 'Active')`,
                [office.name, office.code]
            );
            console.log(`  ✓ Created ${office.code}: ${office.name}`);
        }

        console.log('\n✅ Sub-office setup complete!');
        console.log('You can now navigate: Ilocos Region → ORD → ITSM/AD/FD/PMD/TOD');

    } catch (error) {
        console.error('Error:', error.message);
    } finally {
        await pool.end();
    }
}

insertSubOffices();
