/**
 * Script to insert sub-offices for top-level offices (FAS, FOS, TOS) in Ilocos Region
 * Run with: node insertAdditionalSubOffices.js
 */
const pool = require('./config/db');

async function insertAdditionalSubOffices() {
    try {
        console.log('Starting data population for Additional Sub-Offices (Region 6 - Ilocos)...');

        // Define the hierarchy
        const topOffices = [
            {
                code: 'FAS',
                name: 'Finance and Administrative Services',
                subUnits: [
                    { code: 'HR', name: 'Human Resource Section' },
                    { code: 'ACCT', name: 'Accounting Section' },
                    { code: 'BUD', name: 'Budget Section' },
                    { code: 'CASH', name: 'Cashier Section' },
                    { code: 'SUP', name: 'Supply and Property Section' },
                    { code: 'REC', name: 'Records Management Section' }
                ]
            },
            {
                code: 'FOS',
                name: 'Field Operations Services',
                subUnits: [
                    { code: 'SETUP', name: 'Small Enterprise Technology Upgrading Program' },
                    { code: 'SCH', name: 'Scholarship Unit' },
                    { code: 'CEST', name: 'Community Empowerment thru Science & Technology' },
                    { code: 'GIA', name: 'Grants-In-Aid Unit' }
                ]
            },
            {
                code: 'TOS',
                name: 'Technical Operations Services',
                subUnits: [
                    { code: 'RSTL', name: 'Regional Standards and Testing Laboratory' },
                    { code: 'MIS', name: 'Management Information System' },
                    { code: 'DRRM', name: 'Disaster Risk Reduction Management' }
                ]
            }
        ];

        for (const officeDef of topOffices) {
            console.log(`\nProcessing ${officeDef.code}...`);

            // 1. Find or Create Top Level Office
            let parentId;
            const parentRes = await pool.query(
                `SELECT office_id FROM offices WHERE code = $1 AND region_id = 6 AND parent_id IS NULL`,
                [officeDef.code]
            );

            if (parentRes.rows.length === 0) {
                console.log(` - Creating parent office: ${officeDef.code}`);
                const insertRes = await pool.query(
                    `INSERT INTO offices (name, code, region_id, status) VALUES ($1, $2, 6, 'Active') RETURNING office_id`,
                    [officeDef.name, officeDef.code]
                );
                parentId = insertRes.rows[0].office_id;
            } else {
                parentId = parentRes.rows[0].office_id;
                console.log(` - Found existing parent: ${officeDef.code} (ID: ${parentId})`);
            }

            // 2. Insert Sub-Units
            for (const sub of officeDef.subUnits) {
                // Check if exists
                const checkRes = await pool.query(
                    `SELECT office_id FROM offices WHERE code = $1 AND parent_id = $2`,
                    [sub.code, parentId]
                );

                if (checkRes.rows.length === 0) {
                    await pool.query(
                        `INSERT INTO offices (name, code, region_id, parent_id, status) VALUES ($1, $2, 6, $3, 'Active')`,
                        [sub.name, sub.code, parentId]
                    );
                    console.log(`   + Created sub-unit: ${sub.code}`);
                } else {
                    console.log(`   . Sub-unit ${sub.code} already exists`);
                }
            }
        }

        console.log('\n✅ Population Complete!');

    } catch (error) {
        console.error('Error:', error);
    } finally {
        await pool.end();
    }
}

insertAdditionalSubOffices();
