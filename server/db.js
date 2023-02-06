import mysql2 from 'mysql2'
import dotenv from 'dotenv';

dotenv.config({ path: './config/.env' })

const connection = mysql2.createConnection({
     host: process.env.DB_HOST,
     user: process.env.DB_USERNAME,
     password: process.env.DB_PASSWORD,
     database: process.env.DB_DATABASE,
})

connection.connect((err) => {
     if (err) console.log(err)
     console.log('Connected to Database')
})

export default connection