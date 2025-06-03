const fs = require('fs')
const path = require('path');

let filename = 'data.txt'

function readData(callback){
    fs.readFile(filename, 'utf-8', (err, data)=>{
        if(err){
            console.log('Something went wrong')
        }
        callback(data)
    })
}

function processData(data){
    let lines = data.split('\n')
    for (let i = 0; i < lines.length; i++){
        if(lines[i] !== ""){
        console.log("Line", i+1, ":", lines[i])
        }
    }
}

function writeLog(message){
fs.appendFileSync('log.txt', message + "\n")
console.log("Log written")
}

readData((result)=>{
    processData(result)
    writeLog("Processed file " + filename)
})

const unusedVar = 123;
