import express from 'express';
import connection from '../db.js'
import { validateUrl } from '../utils/utils.js'
import { uniqueId } from '../utils/utils.js'

const router = express.Router()

router.post('/short', async (req, res) => {
     const { origurl } = req.body
     let urlId = 's/' + uniqueId()

     const sqlselectshort = 'SELECT * FROM `urls` WHERE `shortUrl` = ?';
     const sqlselectorig = 'SELECT * FROM `urls` WHERE `origUrl` = ?';

     if (validateUrl(origurl)) {
          console.log(`generated ${origurl}`)
          try {
               connection.query(sqlselectorig, [origurl], (err, response) => {

                    if (err) {
                         console.error(err);
                         response.send(err);
                         return;
                    }

                    if (response && response.length > 0) {
                         return res.json({
                              message: "Shortened",
                              description: "URL Found",
                              url: response[0].origUrl,
                              short: response[0].shortUrl,
                         })
                    } else {
                         let shorturlCheck = false
                         do {
                              connection.query(sqlselectshort, [urlId], (err, response) => {
                                   if (err) {
                                        console.error(err);
                                        response.send(err);
                                        return;
                                   }
                                   if (response && response.length > 0) {
                                        shorturlCheck = false
                                        urlId = 's/' + uniqueId() //generates again until 'shorturlCheck' is set to true
                                   } else {
                                        shorturlCheck = true
                                   }
                              })
                         } while (shorturlCheck) {
                              const sqlinsert = 'INSERT INTO `urls` (origUrl, shortUrl) VALUES(?, ?)';
                              connection.query(sqlinsert, [origurl, urlId], (err, response) => {
                                   console.log(response.insertId)

                                   const sqlselectresult = 'SELECT * FROM `urls` WHERE id = ?';
                                   connection.query(sqlselectresult, [response.insertId], (error, result) => {
                                        if (error) {
                                             console.error(error);
                                             res.send(error);
                                             return;
                                        }
                                        res.json({
                                             message: 'Shortened',
                                             description: "URL inserted",
                                             url: result[0].origUrl,
                                             short: result[0].shortUrl
                                        });
                                   })
                              })
                         }
                    }
               })
          } catch (error) {
               res.status(500).json('Server Error')
               // console.log(error)
          }
     } else {
          res.status(400).json({ message: 'Invalid Url' })
     }
})

export default router