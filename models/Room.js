const mongoose=require('mongoose')
const {playerschema}=require('./Player')

const roomschema=new mongoose.Schema({
    word:{
        required:true,
        type:String,
    },
    name:{
        required:true,
        type:String,
        trim:true,
        unique:true,
    },
    occupancy:{
        required:true,
        type:Number,
        default:4,
    },
    maxrounds:{
        required:true,
        type:Number,
        default:4,
    },
    currentround:{
        required:true,
        type:Number,
        default:1,
    },
    players:[playerschema],
    isjoin:{
        type:Boolean,
        default:true,
    },
    turn :playerschema,
    turnindex:{
        type:Number,
        default:0,
    }
})

const gamemodel=mongoose.model('Room',roomschema)
module.exports= gamemodel
