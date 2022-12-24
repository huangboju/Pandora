var x = [];
var y = [];
var radius = [];
var transparent = [];
var transPlus = [];
var velX = [];
var velY = [];
var accY = [];
var accX = [];
var state = 0;
var count = 500;
var power = 0;

function changeState(s, power) {
    state = s
    power = p
}

function setup() {
    createCanvas(1500, 1500);
    reset();
    background(30,30,30);
}

function draw() {
    if(state==0){
        count = 50;
        bg = color(38,175,159,200);
    }
    else if(state==1){
        count = 70;
        bg = color(127,168,39,200);
    }
    else if(state==2){
        count = 90;
        bg = color(218,160,35,200);
    }
    else if(state==3){
        count = 130;
        bg = color(212,110,15,200);
    }
    else if(state==4){
        count = 150;
        bg = color(193,86,52,200);
    }
    background(bg);
    noStroke();

    for(var i=0; i<count; i++){
        if(transPlus[i]<transparent[i]){
            transPlus[i]+=3;
        }

        var dynamicTrans = 0;
        dynamicTrans = parseInt((0.1+x[i]/width)*transPlus[i]);
        //if(power!=0) dynamicTrans =var((0.1+x[i]/width)*(1-y[i]/height)*transPlus[i]);
        noStroke();
        fill(255,255,255,dynamicTrans);
        ellipse(x[i],y[i],radius[i], radius[i]);
        x[i]+=velX[i];
        y[i]+=velY[i];
        if(x[i]<=0-radius[i]||x[i]>=width+radius[i]){
            x[i] = random(0, width);
            velX[i] = random(-0.4, 0.4);
            transPlus[i] = 0;
        }

        if(y[i]<=0-radius[i]){
            y[i] = random(0, height);
            velY[i] = random(-0.4, 0.4);
            transPlus[i] = 0;
        }
        if(y[i]>=height+radius[i]){
            y[i] = random(0, height);
            velY[i] = random(-0.4, 0.4);
            x[i] = random(0, width);
            velX[i] = random(-0.4, 0.4);
            transPlus[i] = 0;
        }
        if(power!=0) velX[i] += accX[i]*power;

    }
}

function reset(){
    for(var i = 0; i<count; i++){
        x[i] = random(0, width);
        y[i] = random(0, height);
        radius[i] = random(8,16);
        transparent[i] = parseInt(random(80,180));
        velX[i] = random(-0.4, 0.4);
        velY[i] = random(-0.4, 0.4);
        accY[i] = random(0, 0.008);
        accX[i] = (20-radius[i])/500;
        transPlus[i] = 0;
    }
}
