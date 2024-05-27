const mongoose=require('mongoose')

const playerschema=new mongoose.Schema({
    nickname:{
        type:String,
        trim:true,
    },
    socketid:{
        type:String,
    },
    ispartyleader:{
        type:Boolean,
        default:false,
    },
    points:{
        type:Number,
        default:false,
    }
})


const playermodel=mongoose.model('Player',playerschema)
module.exports={playermodel,playerschema}