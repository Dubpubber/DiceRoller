boolean isRolling = false;
// Number to display to user //
// Used cause we cannot pause drawing //
String output = "0";
// How many times could the die roll? (Die landing on a face)
int maxInterval = 1;

// Scenes //
Scene mainMenu;
// Active scene (currently displaying) //
Scene activeScene = null;

void setup() {
  noLoop();
  size(500, 500);
  mainMenu = new Scene(
    color(255, 255, 255),
    new Button("Flip Coin", "ROLL 2", 255, 255, 255, 1, 25, 25, 150, 25),
    new Button("Roll D4", "ROLL 4", 255, 255, 255, 1, 25, 54, 150, 25),
    new Button("Roll D6", "ROLL 6", 255, 255, 255, 1, 25, 83, 150, 25),
    new Button("Roll D8", "ROLL 8", 255, 255, 255, 1, 25, 112, 150, 25),
    new Button("Roll D12", "ROLL 12", 255, 255, 255, 1, 25, 141, 150, 25),
    new Button("Roll D20", "ROLL 20", 255, 255, 255, 1, 25, 170, 150, 25),
    new Button("Roll D32", "ROLL 32", 255, 255, 255, 1, 25, 199, 150, 25),
    new Button("Roll D64", "ROLL 64", 255, 255, 255, 1, 25, 228, 150, 25)
  );
  if(activeScene == null) {
    activeScene = mainMenu;
    mainMenu.toggle();
  }
}

void draw() {
  if(!isRolling) {
    textSize(16);
    activeScene.update();
  } else {
    background(activeScene.background);
    textSize(64);
    text(output, (width / 2), height / 2);
  }
}

void simulateRollN(int sides) {
  if(sides == 2) {
    output = (int(random(0, 2)) == 1) ? "Heads" : "Tails";
    fill(255, 0, 0);
    redraw();
    delay(1500);
    isRolling = false;
    redraw();
  } else {
    for(int i = 0; i < maxInterval; i++) {
      output = str(floor(random(1, sides + 1)));
      fill(0, 0, 0);
      redraw();
      if(maxInterval <= 12) delay(1000 / maxInterval);
      else delay(135);
    }
    fill(255, 0, 0);
    redraw();
    delay(3000);
    isRolling = false;
    redraw();
  }
}

void mouseClicked() {
  if(activeScene != null) {
    String cmd = activeScene.mouseCheck();
    if(cmd != null) {
      if(match(cmd, "ROLL") != null) {
        // We've received a roll command //
        int sides = int(split(cmd, " ")[1]);
        if(sides > 0) {
          isRolling = true;
          maxInterval = int(random(5, 28));
          simulateRollN(sides);
        } else
          println("Can't have negative sides; now can we?");
      }
    } else {
      println("Didn't receive a command despite hitting a button."); 
    }
  }
}

class Scene {
  // All buttons in this scene.
  ArrayList<Button> buttons;
  
  // Is the scene displaying?
  boolean active = false;
  
  color background = color(0, 0, 0);
  
  Scene(color background, Button... btns) {
    this.background = background;
    this.buttons = new ArrayList();
    for(Button b : btns) buttons.add(b);
  }
  
  void update() {
    background(background);
    if(active && buttons.size() > 0) {
      for(Button b : buttons) {
        b.update();
      }
    }
  }
  
  String mouseCheck() {
    for(Button b : buttons) {
      if(b.mouseCheck()) return b.command;
    }
    return null;
  }
  
  void toggle() {
    active = !active;
  }
  
}

class Button {
  // Button text //
  String text = "Button";
  float r, g, b, alpha;
  // Callback command //
  String command;
  // Position //
  int posX, posY;
  // Dimensions //
  int sizeX, sizeY;
  
  Button(String text, String command, float r, float g, float b, float alpha, int posX, int posY, int sizeX, int sizeY) {
    this.text = text;
    this.command = command;
    this.r = r; this.g = g; this.b = b;
    this.alpha = alpha;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    this.posX = posX;
    this.posY = posY;
  }
  
  void update() {
    fill(0, 0, 0);
    rect(posX, posY, sizeX, sizeY);
    textAlign(CENTER);
    fill(255, 255, 255);
    text(text, (posX + (sizeX / 2)), (posY + (sizeY / 2)) + 5);
  }
  
  boolean mouseCheck() {
    return (mouseX >= posX && mouseX <= (posX + sizeX)) && (mouseY >= posY && mouseY <= (posY + sizeY));
  }
  
  void click(int r, int g, int b) {
    this.r = r; this.g = g; this.b = b;
  }
  
}