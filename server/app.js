import express from 'express'
import dotenv from 'dotenv'
import urlrouter from './routes/urls.js'
import shortrouter from './routes/shorts.js'


const app = express()
dotenv.config({ path: './config/.env' })

app.use(express.urlencoded({ extended: true }));
app.use(express.json());


app.use('/', shortrouter)
app.use('/api', urlrouter);




const PORT = process.env.PORT || 7000

app.listen(PORT, () => {
     console.log(`running at port ${PORT}`)
})



// connection

