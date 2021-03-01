/*
What my program does: 
 This program is a replica flappy bird game. The user will start off the game on the starting screen, on this screen they will click the "Start game" button. 
 By clicking this button they will be brought to the actual game. They can control the bird and guide it through the green zone and avoid hitting the red zone. If they hit the red zone, the game
 is over and they will be brought to the game over screen. On this screen they can click the "Restart" button to try again. Each time the user sucesfully passes through a tube, the score board will be
 updated and incremented by 1. When the score reaches 5, a bouncing power up will appear. This is a yellow rectangle that will bounce around the screen while the score if 5. If the power up is caught by
 the user, then 2 points will be added to their score. However if they dont catch it in time, the power up will disappear. When the score reaches 10, a second bird will appear. The user will control
 this second bird with the 'n' key on the keyboard. The user must guide both bird 1 and bird 2 simultaneously through the safe zones.
 
 What additional elements does my program have:
 - Scoreboard 
 - Start screen
 - Game over screen
 - Buttons
 - Power up (bounces around the screen)
 - 2 bird appear when score reaches 10
 
 
 */


// define variables
float powerX, powerY, powerSpeedX, powerSpeedY; // variables for the powerup
float blockX, blockY, blockH, birdY, birdX, sy, bird2X, bird2Y, sy2; //variables for blocks, both birds, and speed of both birds (y coord)
int score, screen; //variables for the current score and current screen 
PImage startScreen, inGame; //image variables
int buttonWidth, buttonHeight; //button rect variables
int startGameX, startGameY; //button 
int powerSize, speed; // powerup rect size variables and speed 
int powerFlag; // powerup flag variable (used a int rather than a bool so I can three states rather than 2)
int bird2Flag; // flag for bird 2


//creates the size of the screen and assigns values to variables
void setup() {
  size(640, 480);

  score = 0;

  screen = 0;
  /*
  screen table of contents:
   0 - Start screen
   1 - in game
   2 - Game over screen  
   */

  startScreen = loadImage("start screen.png"); //loads the start screen image
  inGame = loadImage("in game.png"); //loads the image that is used in game


  //bird 1
  birdY = 240;  
  birdX = 150; 
  sy = 0;


  //bird 2
  bird2Y = 240;
  bird2X = 150;
  sy2 = 0;
  bird2Flag = 0;


  //sets the size of the block
  blockX = 640;
  blockY = 200;
  blockH = 80;

  //sets the size of the button
  buttonWidth = 200;
  buttonHeight = 50;
  startGameX = 200;
  startGameY = 150;

  //sets the size, starting position and speed of the powerup, and sets the flag variable to 0
  powerSize = 30; 
  powerX = 640;
  powerY = 560;
  speed = 2; 
  powerSpeedX = speed;
  powerSpeedY = speed;
  powerFlag = 0;
}

void draw() {
  background(0);

  //START MENU
  if (screen == 0) { 

    background(startScreen); //sets the background to the image at variable 'start screen'

    //title
    fill(#121415); // sets the text colour
    textSize(40); //sets the text size
    text("Welcome to flappy bird!", 100, 50); //displays the text


    //start button
    rect(startGameX, startGameY, buttonWidth, buttonHeight); //creates a rect according to our variables
    fill(#FFFFFF); //sets the text colour
    textSize(30); //sets the text size
    text("Start Game", startGameX + 20, startGameY + 35); //displays the text


    //IN GAME
  } else if (screen == 1) {

    background(inGame); //sets background to the image at variable 'inGame'

    fill(#FEFF00); //sets the colour of the bird 1
    ellipse(birdX, birdY, 30, 30); //creates circle which is bird 1


    birdY = birdY + sy; //bird 1 movement

    sy = sy + 0.1;//gravity for bird 1


    //scoreboard 
    fill(#F203FF);
    rect(0, 0, 80, 60);
    fill(#FFFFFF);
    textSize(35);
    text(score, 30, 40);


    // creates safe zone for bird to pass through
    fill(0, 255, 0); //sets the colour to green
    rect(blockX, blockY, 50, blockH); //creates the safe rect the bird can pass through safely

    //Creates the unsafe zones (the tubes)
    fill(255, 0, 0); //sets the colour to red
    rect(blockX, 0, 50, blockY); //Creates the top unsafe tube
    rect(blockX, blockY + blockH, 50, height - (blockY + 50)); //Creates the bottom unsafe tube

    blockX = blockX - 1; //tube movement - this line of code subtracts 1 from blockX each frame, therefore the x coord of the block is moved each frame creating the illusion that the tube is moving


    //powerup bounce
    if (score == 5 && powerFlag == 0) { //if the score is equal to 5 and the powerFlag variable is equal to 0 the  go inside this if statment

      fill(#E0FF00);
      rect(powerX, powerY, powerSize, powerSize); //creates a rect that will be the powerup
      powerX = powerX + powerSpeedX; //add powerSpeedX to powerX constantly which will make the rect move horizontally
      powerY = powerY + powerSpeedY; //add powerSpeedY to powerY constantly which will make the rect move vertically
      if (powerX < 0) powerSpeedX = speed; // if the X coord of the powerup is less than zero set powerSpeedX to speed which will move the powerup block to the right when it hits the left edge of the screen
      if (powerX + powerSize > width) powerSpeedX = -speed; //if powerX plus powerSize (which is the width of the block) is greater than the width of the screen then set powerSpeedX to -speed which will make the powerup go the other way when it hits the edge of the screen

      if (powerY < 0) powerSpeedY = speed; //if powerY is less than 0 (which is the top edge of the screen) then move the block down
      if (powerY + powerSize > height) powerSpeedY = -speed; //if powerY plus the size of the powerblock (which is the bottom edge of the block) is greater than the height of the screen, then move the block up

      //power up collision
      if (birdX > powerX && birdX < powerX + powerSize && birdY >  powerY && birdY < powerY + powerSize) { //if the bird collides with the power up the go inside this if statment.... this collision detection is coded by using the birds coord's and the powerups coord's. 
        powerFlag = 1; //this sets the powerFlag to 1... this way we now know that the powerup has been caught
      }
    }



    if (powerFlag == 1) { //if the powerup has been caught increase the score 
      score = score + 2; //adds 2 to the score because the user caught the power up
      powerFlag = 2; //sets the power flag to 2, this way the program knows that we already caught the power up and applied it to our score
    }



    //new block generator
    if (blockX < -50) { //if the x coord of a block is less than -50 then go into this if statment
      blockX = width + 100; //
      blockY = 100 + floor(random(200));
      blockH = 100 + floor(random(50));
      score += 1;
    } 


    //Bird 1 collision detection
    if (birdX > blockX && birdX < blockX + blockH) { //if the bird is within the x coords of the tubes then go into this if statment
      if (birdY > blockY && birdY < blockY + blockH) { //if the bird's Y coords are within the safe zone go inside this if statment
        print("safe");
      }
      if (birdY > blockY && birdY > blockY + blockH || birdY < blockY && birdY < blockY + blockH) { //if the bird's Y coords are within the red zone go inside this if statment
        screen = 2; //set the screen to 2 because the bird crashed
        if (powerFlag == 2) { //if the powerflag is equal to 2 go inside this if statment
          screen = 2; //set the screen to 2 because the bird crashed
        }
      }
    }

    //bird 2 
    if (score >= 10) { //if the score is equal to or greater than 10 go inside this if statment
      fill(#08FFC3); //set the colour of the bird
      ellipse(bird2X, bird2Y, 30, 30); //draw the bird
      bird2Y = bird2Y + sy2; //bird 2 movement 
      sy2 = sy2 + 0.1;//bird 2 gravity
      bird2Flag = 1;
    }

    //bird 2 Collision Detection (some logistics as bird 1 except I used bird 2's variables, I am not explaning this block of code because its basiclly the exact same as lines 159-174, which i already explained)
    if (bird2Flag == 1) {
      if (bird2X > blockX && bird2X < blockX + blockH) {
        if (bird2Y > blockY && bird2Y < blockY + blockH) { //safe zone
          print("safe");
        }
        if (bird2Y > blockY && bird2Y > blockY + blockH || bird2Y < blockY && bird2Y < blockY + blockH) { //bottom tube
          screen = 2;
          if (powerFlag == 2) {
            screen = 2;
          }
        }
      }
    }


    //restart game screen
  } else if (screen == 2) { //is the screen is equal to 2 go inside this if statment
    //start menu
    background(#29A285); //sets the background

    fill(#121415); //sets the text colour
    textSize(40); //sets the text size
    text("Game Over!", 200, 50); //displays the text on the screen

    textSize(25);
    text("Your final score is: " + score, 180, 120); //displays the final score

    //start button (same logistics as previous one, lines 78-81)
    rect(startGameX, startGameY, buttonWidth, buttonHeight);
    fill(#FFFFFF);
    textSize(30);
    text("Restart", startGameX + 50, startGameY + 35);
  }
}


void keyPressed() {

  //bird 1 control
  if (key == ' ') { //if the key pressed is the space bar go into this if statment
    sy = sy - 4; //subtract the sy variable by 4, this will make bird 1 move up each time the user hits the space bar
  }

  if (key == 'n') { // if the key pressed is 'n' then go inside this if statment
    sy2 = sy2 - 4; //subtract the sy2 variable by 4, this will make bird 2 move up each time the user hits the space bar
  }
}


void mousePressed() {
  //start screen - start button
  if (screen == 0) { //if the screen equals zero go inside this if statment
    if (mouseX > startGameX && mouseX < startGameX + buttonWidth && 
      mouseY > startGameY && mouseY < startGameY + buttonHeight) { //if the mouse is clicked within the area of the button then go inside this if statment
      screen = 1; //set the screen to 1, this will start the game
    }
  }

  //game over screen - restart button 
  if (screen == 2) { //if the screen equals 2 go inside this if statment
    if (mouseX > startGameX && mouseX < startGameX + buttonWidth && 
      mouseY > startGameY && mouseY < startGameY + buttonHeight) { //if the mouse is clicked within the area of the button then go inside the if statment

      //reset all the variables or else the game will contuine from where it left off last, this will also restart the game
      score = 0;
      screen = 0;
      startScreen = loadImage("start screen.png");
      inGame = loadImage("in game.png");
      /*
       0 - main menu
       1 - in game
       2 - lose  
       */


      birdY = 240;  
      birdX = 150; 
      sy = 0;

      blockX = 640;
      blockY = 200;
      blockH = 80;

      buttonWidth = 200;
      buttonHeight = 50;

      startGameX = 200;
      startGameY = 150;

      powerSize = 30; 
      powerX = 640;
      powerY = 560;
      speed = 2; 
      powerSpeedX = speed;
      powerSpeedY = speed;
      powerFlag = 0;

      //resets the game to screen 1
      screen = 1;
    }
  }
}
