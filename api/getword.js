const getword =()=>{
    const words=[
        "camel",
        "giraffe",
        "eiffel tower",
        "ligma",
        "the rock",
        "siuuuu",
        "four arms",
        "kick buttawoski",
        "walter white",
        "thomas shelby"

    ]
    return words[Math.floor(Math.random()*words.length)]
}

module.exports=getword