/** 
    Cortes, Project 2, CISC 1600
 
    Small game where player controls an avatar and must avoid incoming triangles. 
 
    Game mechanics will include: 
 
        Game will include a current score. 
        Game will include a highscore. 
        Game will have variable speed. 
        Game will have mouse clicking interactability. 
        Game will have mouse position interactability. 
        Game will have keyboard pressing interactability. 
        Game will have randomized variables. 
        Game will have a counter system. 
        Game will have a level system. 
        Game will have multiple screens. 
        Game will include time mechanics. 
**/ 


/** 
    Edit: Looking back through the code I realize that I did a terrible job of commenting.
    This edit is so that I can explain the game mechanics.
	The gameState variable is arguably one of the most important; it basically defines how the game will proceed.
    First it guides the game through the epilepticWarning() function. That is just a page that uses a timer variable 'frames'
    to display some text. After a while it accepts a mouse-click to move on. gameState then moves the game on to the startScreen(),
    which displays basic information like the current highscore and the current 'speed' (it's the speed variable that is managed
    by the user). It also features the "Start" button which calls the newVariables() and moves the gameState variable on to make
    us go to the instructions page. The instructions() function uses a game sub-guide variable miniGameState. That takes us
    through 4 sub-methods that explain the objective, the mechanics, and the hotkeys. Once those 3 pages are displayed (as
    of this edit 1 of the 4 miniGameState 's is not used, thus only 3 pages) gameState takes us to the main game. It involves
    a variable 'h', which is initialized to just off the right edge. 'h' also serves to plot out my triangles. It plots the
    bottom-left coordinate of the leading triangle (which is the bottom-left triangle), all other triangles are drawn based
    on that one. As the game progresses I subtract a combination of the 'level' and 'speed' variables from 'h', thus "moving"
    the triangles. After calling the triangles() function I call the circleCursor() function, which draws the avatar. Then I
    call the checkGame() which basically decides on whether the game has been lost. It uses the leftmost X coordinate and the
    topmost Y coordinate of the leading triangle (which is the bottom-left triangle) to determine if the player has successfully
    passed through the triangles. I'd like to point out that during the actual gameplay state I could take other routes besides
    the next logical step, which would be the gameover state. One potential gameState would be by pressing the 'p' key. That
    would prompt a Pause menu, which displays information about the game and the ability to continue. Another potential
    gameState would be accessed by right-clicking on the screen; that would take me to the speedIncrease() function which
    allows for the management of the 'speed' variable. It also serves as a different Pause menu, because it literally pauses
    the game plus it allows for the ability of quitting. Yet a different gameState route from the actual gameplay screen would
    be the levelUpScreen() function, which just informs the user that the game difficulty has been increased. It is prompted
    by successfully passing through 4 sets of triangles. Back to the LOGICAL steps of gameState: should the player fail passing
    through the triangles, then gameState takes us the the gameOver() function. the gameOver screen displays the information
    about the game and asks if the player would like to try again. When the player accepts the try again button, gameState
    returns to 1, which is the startScreen() function.
**/

 
/** 
    This section will have variable declarations
**/
 
/** 
    Critical member variables. 
**/
// The 'h' variable works as an offset and also a coordinate. As a coordinate it serves the purpose of being the leading
// triangle's bottom-left coordinate. From there all other triangles are duplicates. As an offset: it is always initialized
// to 60 pixels off the right edge. Every frame I subtract whatever the variable "speed" is, plus two times the current level.
// e.g. I subtract ((level*2)+speed) FROM h, this way every frame the triangles appear to "move" towards the left.
int h;
//The main scheduler of the game screens. Determines which screen to display. 
int gameState; 
//A sub-scheduler; used for guiding through the multiple instruction pages. 
int miniGameState = 0; 
//The 'frames' variable works as my general counter. Some methods use a different counter, but 'frames' is my broadest counter. 
int frames = 0; 
//cursorSize defines the diameter of my circle cursor. 
int cursorSize = 12; 
//'speed' defines how fast the triangles will go across the screen. This one is static and only managed by the user;
// the game does not change the 'speed' variable, it only initializes it to 3. I then go ahead and subtract twice the 'level'
// plus the 'speed' from the offset variable 'h' (h - ((level*2)+speed)), which is also my leading coordinate, thus "moving"
// my triangles across the map.
int speed ; 
//'level' works the same way as the 'speed' variable. Only difference is that this variable is managed by the game.
// Basically every 4 successful sets of passed triangles will trigger a "Level Up", and an increase in the 'level' variable
// (every successful pass of triangles is kept track by the 'counter' variable). I then go ahead and subtract twice the 'level'
// plus the 'speed' from the offset variable 'h' (h - ((level*2)+speed)), which is also my leading coordinate, thus "moving"
// my triangles across the map.
int level; 
/** 
    The following variables are not necessary. 
**/
//Simple flag that can be either 0 or 1. 0 is a safe gameover, 1 is a suspected-cheating gameover. 
int reason; 
//'counter' keeps track of the sub-level. 
int counter; 
//Keeps track of the "highscore", but does not take into account of the sub-level. 
int highscore; 
//Simple flag that allows the user to bypass the instructions once they've seen them once. 
bool instruct; 
//Basically defines the distance between the four triangles. A random value from 150 pixels to 250. 
int triangleDistance; 
/** 
    The following variables are pretty much redundant. 
**/
//I don't know why this is used since it is the same as the mouseX keyword. 
int mouseXPosi ;
//I don't know why this is used since it is the same as the mouseY keyword. 
int mouseYPosi ;
//Basically these variables define the height of the triangles. The "..Top" variables are initialized to a random value
// from the bottom of the screen to 25 pixels off the top. The "..Bot" variables are then initialized to 25 pixels higher
// than their respective "..Top" variable.
//Honestly don't know why I declared them all, most of them aren't even used. 
int randHeightOneTop;
int randHeightOneBot; 
int randHeightTwoTop; 
int randHeightTwoBot; 
int randHeightThrTop;
int randHeightThrBot; 
int randHeightFouTop;
int randHeightFouBot;
//The X coordinate is the leftmost coordinate of its respective triangle (basically the 'h' variable). The Y coordinate
// is the "randHeight...Top" variable of its respective triangle.
//Same as above, I honestly don't know why I declared them all, again, most of them aren't even used. 
int triangleOneX; 
int triangleOneY;
int triangleTwoX; 
int triangleTwoY; 
int triangleThrX; 
int triangleThrY; 
int triangleFouX; 
int triangleFouY; 
 


/**
    This section will have Processing functions
**/ 
 

void setup() {  
    
    size(900, 300); 
    frameRate(60);
    stroke(12);  
    newVariables(); 
	
	gameState = 0; 
	speed = 3; 
	level = 0; 
	reason = 0; 
	counter = 0;
	highscore = 0; 
	instruct = false; 
}
 
void draw() {  
    
    if (gameState == 0) {
        epilepticWarning(); 
    }
    if (gameState == 1) {
        startScreen(); 
    }
    if (gameState == 2) {
        instructions(); 
    }
    if (gameState == 3) {
        mouseXPosi = mouseX ;
        mouseYPosi = mouseY ;
		
        triangles() ;
        circleCursor() ;
        checkGame() ;
    }   
    if (gameState == 4) {
        gameOver() ;
    }
    if(gameState == 5) {
        pauseScreen(); 
    } 
    if (gameState == 6) {
        levelUpScreen(); 
    }
    if (gameState == 7) {  
        speedIncrease();
    }
    frames= frames + 1; 
}

/**
    Listener functions
**/ 
 
//Mouse clicking listener. If right click, moves the gameState varible to 1 (used for speedIncrease() function)
void mousePressed() {      
    if (mousePressed == true && (mouseButton == RIGHT) && (gameState == 3) ) {
        gameState = 7; 
    }
} 
 
//Keyboard listener. If 'p' is clicked, moves the gameState variable to 4 (used for pauseScreen() function)
void keyPressed() {
    if (keyPressed == true && ( key == 'p' ) && (gameState == 3) ) {
        gameState = 5;
    }
}

 
/**
    This section will have other functions defined by me
**/ 

 
//Randomizing variables function. Creates new random variables that are used for drawing the triangles. 
void newVariables() {
    
    //Resets variable h
    h = width - 60; 
    
    //Ramdomizes and re-initializes triangle heights. 
    randHeightOneTop = random (0, height-25) ;
    randHeightOneBot = randHeightOneTop + 25 ;
    randHeightTwoTop = random (0, height-25) ;
    randHeightTwoBot = randHeightTwoTop + 25 ;
    randHeightThrTop = random (0, height-25) ;
    randHeightThrBot = randHeightThrTop + 25 ;
    randHeightFouTop = random (0, height-25) ;
    randHeightFouBot = randHeightFouTop + 25 ;  
    
    //Randomizes and re-initializes the distance between triangles. 
    triangleDistance = random (150, 250); 
}
 
//Function that warns user of potential epilepsies. Thought it could be fun. And necessary. 
//Nothing of particular interest, everything is hardcoded. Involves the use of a timer for scheduling text. 
//Leads only to the startScreen() state. 
void epilepticWarning() {
    background (0); 
    
    textAlign (CENTER);
    
    fill (255, 0, 0); 
    textSize (36); 
    text ("Epilepsy Warning", width/2, height/6); 
    
    fill (255, 255, 255); 
    
    if (frames <= 180) {
        textSize (18); 
        text ("THIS GAME HAS BEEN IDENTIFIED", width/2, (height/2)-60); 
        text ("BY EPILEPSY ACTION TO POTENTIALLY", width/2, (height/2)-30); 
        text ("TRIGGER SEIZURES FOR PEOPLE WITH", width/2, (height/2));
        text ("PHOTOSENSITIVE EPILEPSY. ", width/2, (height/2)+30);
    }
    
    textSize(24);     
    if (frames >= 180 && frames <= 330) {
        text ("VIEWER DISCRETION IS ADVISED. ", width/2, height/2);
    }
    if (frames >= 330) {
        text ("CLICK TO CONTINUE", width/2, height/2);
    }
    if((frames >= 330) && (mousePressed == true)) {
        gameState = 1; 
    }
}

//Function that creates the start screen. Prompted after a game over, and at the beginning of the simulation. 
//Nothing of particular interest, everything is hardcoded.  
//Could potentially lead to the instructions() state, gameplay state, or the speedIncrease() state. 
void startScreen() {
    //counter keeps track of the sublevel. 
    counter = 0; 
	//level keeps track of the mainlevel. 
    level = 0; 
    
    background (124, 3, 87) ; 
    textAlign (CENTER); 
    
    textSize (28) ;
    fill (157, 220, 9);
    text ("Epileptic Triangles", width/2, (height/4)-30); 
    
    textSize (16); 
    text ("Instructions will follow on the next screen", width/2, height/2); 
	//Small easter egg; player can bypass the rules if they've already gone through them. 
    if (instruct == true) {
        text ("Hit spacebar to skip the instructions!", width/2, (height/2)+25); 
    }
    
    fill (197, 185, 203); 
    rectMode (CENTER);
    rect (width/2, ((height/4)*3)+30, 150, 40); 
    
    if (frames % 5 == 0) {
        fill (84, 167, 247); 
    } else {
        fill (241, 109, 164); 
    }
    rect (width/6, height/4, 150, 40); 
    rect ((width/6)*5, height/4, 150, 40); 
    
    textSize (16); 
    fill (0, 0, 0); 
    text ("Start!", width/2, ((height/4)*3)+35); 
    text ("Highscore: level " + highscore, width/6, (height/4)+5); 
    text ("Speed: " + speed, (width/6)*5, (height/4)+5); 
    
    if (mousePressed == true && (mouseButton == LEFT) && (mouseX >= 375 && mouseX <=525 && mouseY >= 235 && mouseY <= 275)) {
        frames = 0; 
        gameState = 2; 
    }
    if (mouseX >= ((width/6)*5)-75 && mouseX <= ((width/6)*5)+75 && mouseY >= (height/4)-20 && mouseY <= (height/4)+20){
        if (mousePressed == true && mouseButton == LEFT) {
            gameState=7;
        }
    }
    if (keyPressed == true && (key == ' ') && (instruct == true)) {
        newVariables(); 
        gameState = 3; 
    }
}

//Function that informs the user of the instructions of the game. Thought it useful. 
//instructions() delegates the work using a second scheduler variable, miniGameState. 
//Nothing of particular interest within the pages, everything is hardcoded. Involves the use of a timer for scheduling text and pages. 
//This function indirectly leads to the gameplay state. 
void instructions() {
    if (miniGameState == 0) {
        instructionsScreenOne(); 
    }
    if (miniGameState == 1) {
        instructionsScreenTwo();         
    }
    if (miniGameState == 2) {
        instructionsScreenThree(); 
    }
    if (miniGameState == 3) {
        instructionsScreenFour(); 
    }
}
 
/**
    The next four sub-methods are for the Instruction Pages. 
**/ 
 
//Function that expands on the instruction screen. Decided to delegate the work. 
//This function describes the point of the game. 
void instructionsScreenOne() {
    background (204); 
    
    fill (198, 183, 178); 
    triangle (width/2, 0, (width/2)+60, 0, (width/2)+30, (height/2)-15); 
    triangle (width/2, height, (width/2)+60, height, (width/2)+30, (height/2)+15); 
    
    fill (178, 192, 187); 
    ellipse (width/2, height/2, 10, 10); 
    
    fill (0); 
    textSize (16); 
    textAlign (CENTER); 
    text ("Use the mouse to control the circle", width/4, height/4) 
    text ("You must avoid the triangles", width/4, (height/4)+25); 
    
    if (frames >= 120) {
        fill (207, 109, 158); 
        rect ((width/4)*3, height/6, 150, 40); 
        fill (0); 
        text ("Continue", (width/4)*3, height/6); 
        if (mouseX >= ((width/4)*3)-75 && mouseX <= ((width/4)*3)+75 && mouseY >= (height/6)-20 && mouseY <= (height/6)+20) {
            if (mousePressed == true ){
                miniGameState=1;
                frames=0;
        }
        }
    }
}
 
//Function that expands on the instruction screen. Decided to delegate the work. 
//This function has been left blank in case I wanted to add something in the future. 
void instructionsScreenTwo() {
    miniGameState = 2; 
}
 
//Function that expands on the instruction screen. Decided to delegate the work. 
//This function describes levels and sublevels. 
void instructionsScreenThree() {
    background (204); 
    
    rectMode (CENTER); 
    fill (125, 197, 231); 
    rect (width/4, height/4, 200, 50); 
    
    textAlign (CENTER); 
    textSize(20); 
    fill (0); 
    text ("Highscore: level 3", width/4, height/4); 
    text ("The current score is: 2.3", width/4, (height/4)*3); 
    
    textSize (12); 
    text ("As you can see on the image to the left", (width/5)*3, (height/4)-20); 
    text ("Highscore depends solely on levels", (width/5)*3, height/4); 
    text ("There will be 4 sublevels per 1 level", (width/5)*3, (height/2)-20); 
    text ("Every level increase will be prompted by a screen", (width/5)*3, (height/2)); 
    text ("Every level increase will increase the speed of the game", (width/5)*3, (height/2)+20); 
    text ("Your score will depend on levels and sublevels", (width/5)*3, ((height/4)*3)-20); 
    text ("The first number (2) is the level, and the next (3) is the sublevel", (width/5)*3, (height/4)*3); 
    
    if (frames >= 120) {
        fill (207, 109, 158); 
        rect ((width/4)*3, (height/8)*7, 150, 40); 
        fill (0); 
        text ("Continue", (width/4)*3, (height/8)*7); 
        if (mouseX >= ((width/4)*3)-75 && mouseX <= ((width/4)*3)+75 && mouseY >= ((height/8)*7)-20 && mouseY <= ((height/8)*7)+20) {
            if (mousePressed == true) {
                miniGameState=3;
                frames=0;
            }
        }
    }
}
 
//Function that expands on the instruction screen. Decided to delegate the work. 
//This function describes hotkeys. 
//This function leads directly to the gameplay state. 
void instructionsScreenFour() {
    background (204); 
    
    fill (0); 
    textAlign (CENTER); 
    textSize (40); 
    text("Hotkeys: ", width/2, height/5); 
    
    textSize (16); 
    text ("You can hold 'P' while on the game to pause the game", width/2, (height/4)+15); 
    text ("You can right-click while on the game to change the speed", width/2, (height/4)+40); 
    text ("Hint: Hit spacebar next time you're in the menu to skip the instructions", width/2, (height/10)*9); 
    
    if (frames >= 120) {
        text ("Most importantly.. ", width/2, (height/4)+75); 
    }
    if (frames >= 240) {
        text ("Do not shake the mouse while playing", width/2, (height/4)+95); 
        text ("I might think you're cheating", width/2, (height/4)+120); 
    }
    if (frames >= 390) {
        fill (207, 109, 158); 
        rect (width/2, (height/4)*3, 150, 40); 
        fill (0); 
        text ("Start!", width/2, (height/4)*3); 
        if (mousePressed == true && (mouseX >= (width/2)-75 && mouseX <= (width/2)+75 && mouseY >= ((height/4)*3)-20 && mouseY <= ((height/4)*3)+20)) {
            newVariables();
            miniGameState = 0;  
            gameState = 3; 
            instruct = true; 
        }
    }
}

/**
    Here is the bulk code of the game 
**/ 
 
//Triangle drawing function. 
//Draws triangle frames, updates variables, etc. 
//Could potentially lead to the gameOver() state, the pauseScreen() state, the levelUpScreen() state, and/or the speedIncrease() state. 
void triangles() {
    
        background (124, 3, 87) ; 
        
        fill (157, 220, 9); 
        textSize (16); 
        text ("Your current speed is: " + speed, width/6, ((height/6)*5)-20); 
        text ("The current highscore is: level " + highscore, width/6, (height/6)*5); 
        text ("The current score is: level " + level + "." + counter, width/6, ((height/6)*5)+20); 
		
		//Randomizing the color so that the "epilepsies" really take effect. 
        
        if (frames % 3 == 2) {
            fill (1, 69, 255) ; 
        } else {
            if (frames % 3 == 1) {
                fill (156, 209, 192); 
            } else {
                fill (167, 190, 207); 
            }
        }
    
        //Triangle drawing is initiated
    
        triangle (h, 0, h+60, 0, h+30, randHeightOneTop); 
        triangle (h, height, h+60, height, h+30, randHeightOneBot); 
    
        triangle (h+triangleDistance, 0, (h+(triangleDistance+60)), 0, (h+(triangleDistance+30)), randHeightTwoTop) ;
        triangle (h+triangleDistance, height, (h+(triangleDistance+60)), height, (h+(triangleDistance+30)), randHeightTwoBot); 
    
        triangle (h+(triangleDistance*2), 0, (h+((triangleDistance*2)+60)), 0, (h+((triangleDistance*2)+30)), randHeightThrTop) ;
        triangle (h+(triangleDistance*2), height, (h+((triangleDistance*2)+60)), height, (h+((triangleDistance*2)+30)), randHeightThrBot); 
    
        triangle (h+(triangleDistance*3), 0, (h+((triangleDistance*3)+60)), 0, (h+((triangleDistance*3)+30)), randHeightFouTop) ;
        triangle (h+(triangleDistance*3), height, (h+((triangleDistance*3)+60)), height, (h+((triangleDistance*3)+30)), randHeightFouBot); 
		
		//Assigning of the triangle...X and the triangle...Y variables, which is redundant really. 
        
        triangleOneX = h; 
        triangleOneY = randHeightOneTop; 
        
        triangleTwoX = h+triangleDistance; 
        triangleTwoY = randHeightTwoTop; 
        
        triangleThrX = h+(triangleDistance*2); 
        triangleThrY = randHeightThrTop; 
        
        triangleFouX = h+(triangleDistance*3); 
        triangleFouY = randHeightFouTop; 
        
        //Following function used to update highscore (if necessary). 
        
        if (level >= highscore) {
            highscore = level; 
        }
    
        //Erases a combination of "level" and "speed" from h, so that triangles can move across x-axis. 
    
        h = h - ((level*2)+speed); 
        
        //If all triangles (for the most part) most across screen, defines new random variables and updates counter. 
        
        if ( h <= -800) {
            newVariables(); 
            counter = counter + 1; 
        }
		
		//If the player has successfully passed a set of 4 groups of triangles (or sublevels) we increase the level. 
        if (counter % 5 == 4) {
            level = level + 1; 
            counter = 0; 
            gameState = 6; 
            levelUpScreen(); 
            frames = 0; 
        }
}

//Function that draws the avatar. 
//Nothing of particular interest. 
void circleCursor() {
    fill (random(255), random(255), random(255)); 
    ellipse (mouseXPosi, mouseYPosi, cursorSize, cursorSize); 
}
 
//Function that check the condition of the game. Determines on whether there will be a game over. 
//Nothing of particular interest, everything is hardcoded. 
//Could potentially lead to the gameOver() state. 
void checkGame() {
    
    //Checks on whether the cursor has successfully crossed triangle one. 
    if ( mouseXPosi >= triangleOneX+25 && mouseXPosi <= triangleOneX+35) {
        if ( mouseYPosi <= randHeightOneTop || mouseYPosi >= (randHeightOneTop+25) ) {
            reason = 0; 
            gameOver() ;
        }
    }
    
    //Checks on whether the cursor has successfully crossed triangle two. 
    if ( mouseXPosi >= triangleTwoX+25 && mouseXPosi <= triangleTwoX+35) {
        if ( mouseYPosi <= randHeightTwoTop || mouseYPosi >= (randHeightTwoTop+25) ) {
            reason = 0; 
            gameOver() ;
        }
    }
    
    //Checks on whether the cursor has successfully crossed triangle three. 
    if ( mouseXPosi >= triangleThrX+25 && mouseXPosi <= triangleThrX+35) {
        if ( mouseYPosi <= randHeightThrTop || mouseYPosi >= (randHeightThrTop+25) ) {
            reason = 0; 
            gameOver() ;
        }
    }
    
    //Checks on whether the cursor has successfully crossed triangle four. 
    if ( mouseXPosi >= triangleFouX+25 && mouseXPosi <= triangleFouX+35) {
        if ( mouseYPosi <= randHeightFouTop || mouseYPosi >= (randHeightFouTop+25) ) {
            reason = 0; 
            gameOver() ;
        }
    }
    
    //Checks on whether the cursor has moved too violently. Prompts a game over. Fail safe, could deny cheaters. 
    if (mouseX - pmouseX >= 75) {
            reason = 1; 
			gameOver() ;
    }
}

 
//Function that creates the game over simulation. 
//Nothing of particular interest, everything is hardcoded.
//Leads only to the startScreen() state. 
void gameOver() {
    //counter keeps track of the sublevel. 
    counter = 0; 
	//level keeps track of the mainlevel. 
    level = 0; 
    
    gameState = 4; 
    
    background (124, 3, 87) ; 
    textAlign (CENTER); 
    
    textSize (28) ;
    fill (157, 220, 9); 
    text ("Game Over... ", width/4, (height/2)-50); 
    
    fill (1, 69, 255) ; 
    rectMode (CENTER);
    rect ((width/4)*3, height/2, 150, 40); 
    if (frames % 5 == 0) {
        fill (84, 167, 247); 
    } else {
        fill (241, 109, 164); 
    }
    rect (width/2, height/6, 150, 40); 
    rect (width/2, (height/4)*2, 150, 40); 
    rect (width/2, (height/6)*5, 150, 40); 
    
    textSize (16); 
    fill (157, 220, 9); 
    if (reason == 0) {
        text ("Oh no! You lost!", width/4, height/2); 
    } 
    if (reason == 1) {
        text ("Told you I'd think you were cheating", width/4, height/2);
    }
    fill (157, 220, 9); 
    text ("Click to try again!", width/4, (height/2)+25); 
    
    fill (0, 0, 0); 
    text ("Your speed: " + speed, width/2, (height/6)); 
    text ("Your level: " + level, width/2, (height/4)*2); 
    text ("Highscore: " + highscore, width/2, (height/6)*5); 
    text ("Try Again!", (width/4)*3, height/2); 
    
    if (mousePressed == true && (mouseButton == LEFT) && (mouseX >= 600 && mouseX <= 750 && mouseY >= 130 && mouseY <= 170)) {
    
        newVariables(); 
        
        gameState = 1; 
    }
}

//Function that creates the pause screen simulation. 
//Prompted after keyPressed(). 
//Nothing of particular interest, everything is hardcoded. 
//Leads only to the gameplay state. 
void pauseScreen() {
    
    gameState = 5; 
    
    background (124, 3, 87); 
    textAlign (CENTER); 
    
    textSize (28); 
    fill (157, 220, 9);
    text ("Game Paused", (width/4)*3, height/2) 
    
    fill (1, 69, 255); 
    rectMode (CENTER); 
    rect (width/4, height/2, 150, 40); 
    
    if (frames % 5 == 0) {
        fill (84, 167, 247); 
    } else {
        fill (241, 109, 164); 
    }
    rect ((width/4)*3, height/4, 150, 40); 
    
    textSize (16); 
    fill (157, 220, 9); 
    text ("Click on continue to proceed!", (width/4)*3, (height/2)+35); 
    text ("Your current speed is: " + speed, (width/4)*3, (height/2)+55); 
    text ("Your current level is: " + level, (width/4)*3, (height/2)+75); 
    text ("Your current sublevel is: " + counter, (width/4)*3, (height/2)+95); 
    
    fill (0, 0, 0); 
    text ("Continue!", width/4, height/2); 
    text ("Highscore: level " + level, (width/4)*3, height/4); 
    
    if (mousePressed == true && (mouseButton == LEFT) && (mouseX >= 150 && mouseX <= 300 && mouseY >= 130 && mouseY <= 170)) {
        gameState = 3; 
    }
}

//Function that informs the user that the level has gone up. Find it useful. 
//Prompted only from the gameplay state. 
//Nothing of particular interest, everything is hardcoded. 
//Leads only to the gameplay state. 
void levelUpScreen() {
    background(124, 3, 87); 
    textAlign (CENTER); 
    
    fill (157, 220, 9); 
    textSize (40); 
    text ("Level UP!", width/2, height/2); 
    
    textSize(20); 
    text ("Good Luck!", width/2, (height/4)*3); 
    
    if (frames >= 120) {
        text ("Click anywhere to continue", width/2, (height/8)*7); 
    }
    if (frames >= 120 && mousePressed) {
        gameState = 3;
    } 
}

//Function that allows for the change in speed variable, quitting the game, or continuing the game. 
//Prompted after mousePressed(). 
//Nothing of particular interest, everything is hardcoded. 
//Could potentially lead to the gameplay state or the startScreen() state. 
void speedIncrease() {
    
    background (124, 3, 87) ; 
    textAlign (CENTER); 
    
    textSize (28); 
    fill (157, 220, 9); 
    text ("Speed Change Time!", width/2, height/2) ;
    
    fill (1, 69, 255) ;
    rectMode (CENTER); 
    rect (width/4, height/2, 100, 50); 
    rect ((width/4)*3, height/2, 100, 50); 
    rect (0, height, 200, 74); 
    rect (0, 0, 200, 74); 
    
    textSize(16); 
    fill (0, 0, 0); 
    text ("<-Main Menu", 50, 285); 
    text ("<-Cancel", 50, 15); 
    text ("Speed Up!", width/4, height/2); 
    text ("Speed Down!", (width/4)*3, height/2); 
    
    fill (157, 220, 9); 
    text ("As soon as you click an option, the game will start!", width/2, (height/2)+50);
    text ("Your current speed is: " + speed, width/2, (height/2) +75); 
    text ("Your current level is: " + level, width/2, (height/2) +100); 
    
    if (mousePressed == true && (mouseButton == LEFT) && (mouseX >= 175 && mouseX <= 275 && mouseY >= 125 && mouseY <= 175) ) {
        
        speed = speed + 2; 
        newVariables(); 
        gameState = 3 ;
    }
    if (mousePressed == true && (mouseButton == LEFT) && (mouseX >= 625 && mouseX <= 725 && mouseY >= 125 && mouseY <= 175) ) {
        
        speed = speed - 2; 
        
        //Denies the ability for the game to go by at less than 0. Fail safe, could've been a glitch. 
        if (speed <= 0 ) {
            speed = 1; 
        } 
        newVariables(); 
        gameState = 3; 
    }
    if (mousePressed == true && (mouseButton == LEFT) && (mouseX >= 0 && mouseX <= 100 && mouseY >= 263 && mouseY <= height)) {
        gameState = 1; 
    }
    if (mousePressed == true && (mouseButton == LEFT) && (mouseX >= 0 && mouseX <= 100 && mouseY >= 0 && mouseY <= 37)) {
        gameState = 3;
    }
}
