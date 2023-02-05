import mysql2 from 'mysql2'

const connection = mysql2.createConnection({
     host: 'localhost',
     user: 'root',
     password: '',
     database: 'activelamp',
})

connection.connect((err) => {
     if (err) console.log(err)
     console.log('Connected to Database')
})

export default connection