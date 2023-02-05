import express from 'express'
import connection from '../db.js'

const router = express.Router()

router.get('/s/:urlCode', async (req, res) => {
     console.log('hello')

     const findurl = 'SELECT * FROM `urls` WHERE `shortUrl` = ?';
     let urlcode = 's/' + req.params.urlCode
     console.log(urlcode)
     try {
          connection.query(findurl, [urlcode], (err, response) => {
               if (err) {
                    console.log(err)
                    response.send(err)
                    return;
               }

               if (response && response.length > 0) {
                    return res.redirect(response[0].origUrl)
               } else {
                    res.json({
                         message: 'Url does not Exist',
                    })
               }
          })
     } catch (error) {
          console.log(err);
          res.status(500).json('Server Error');
     }
     // res.json({
     //      message: 'Ok',
     //      res: urlCode
     // })
})

export default router