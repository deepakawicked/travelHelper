class Event{
  String name, st, et;
  float startTime, endTime, hr;
  int duration;
  color colour;
  boolean selected;
  
  Event(String n, String st, int d){
    
    //user assignements (based of GUI) 
    this.name = n;
    this.st = st;
    this.duration = d;
    
    //parse hour and minute from String (format "HH::MM");
    int colon = st.indexOf(":"); //
    String hour = st.substring(0, colon);
    String minute = st.substring(colon+1);
    
    //convert star time stringto float 
    if (float(minute) == 30) this.startTime = float(hour) + 0.5;
    else this.startTime = float(hour);
    
    //calculate end time 
    this.hr = ((d - (d%60))/60);
    float min = d % 60;
    float minutes = float(minute) + min;
    
    if (minutes >= 60){ //break into minutes if it wras over 60
      minutes %= 60;
      hr++;//parse up hours 
    }
    
    minutes /= 60; //convert minutes to fraction of an hour 
    this.endTime = float(hour) + hr + minutes; //convert float to string 
    String strEt = str(this.endTime);
    int point = strEt.indexOf("."); //find decimal point
    String hrEt = strEt.substring(0,point); //extract hour part 
    String minEt = str(int(minutes *= 60)); //extract minute 
    
    if (int(minutes) < 10) minEt = "0" + minEt; //pad single-digit minutes with 0
    
    this.et = hrEt + ":" + minEt;
    this.colour = color(rvalue.getValueI(),gvalue.getValueI(),bvalue.getValueI()); //pull information from the sliders in the GUI (RED,GREEN, BLUE SLIDERS)
    this.selected = false;
  }
  
  void drawEvent(){
      
    boolean notBooked = this.checkOverlap(); //check for overlaps with others in the list (if it is, prevents creation)
    
    if (notBooked){ //only draw if evn does not overlap
      
      if (selected){
        textAlign(LEFT);
        textSize(14);
        fill(this.colour);
        
        //create a rectangle with the information - Highlight if the even is celected 
        rect(280, 37.48 + 30.88*(this.startTime-6), 200, 75);
        fill(0);
        text("Location: " + this.name, 290, 60 + 30.88*(this.startTime-6));
        text("Start time: " + this.st, 290, 80 + 30.88*(this.startTime-6));
        text("End time: " + this.et, 290, 100 + 30.88*(this.startTime-6));
        strokeWeight(3);
        stroke(255,0,0); //red border for sleectied 
        
      }
      
      //draw event rectangle in scedule 
      textAlign(CENTER);
      fill(this.colour);
      rect(89, 37.48 + 30.88*(this.startTime-6), 185, this.duration*0.51467);
      
      fill(0);
      text(this.name, 181.5, 40 + 30.88*(this.startTime-6) + ((this.duration*0.51467)/2));
      
      //removes events past midnight
      if (this.endTime > 24) events.remove(this);
      
      
      //prepare drawing for the next elements 
      stroke(0);
      strokeWeight(1);
      textAlign(LEFT);
      textSize(10/displayScale);
      
      
      
      
    }
   else{
     
     fill(222,255,222);
     //rect(width/2-150, height/2-30, 300, 50);
     fill(0);
     //text("Please ensure your events aren't overlapping!", width/2 -130, height/2);
     //println("Please ensure your events aren't overlapping!");
     events.remove(this); //remove event if map is overlapping 
   }
  }
  
  
  //checks if currently being create event overlaps with any other events 
  boolean checkOverlap(){
    //boolean intersection = true;
    for (int i = 0; i < events.size(); i++){
      Event other = events.get(i);
      if (this != other){ //skip self 
      
      //checking different ways two laps can overlap in time 
        if (other.startTime <= this.startTime && this.startTime <= other.endTime) return false; //checks if event starts during the other event 
        else if (other.startTime <= this.endTime && this.endTime <= other.endTime) return false ; //checks if it event ends during the other event 
        else if (this.startTime <= other.startTime && other.endTime <= this.endTime) return false; //checks if the other event is completly inside this event 
        else if (other.startTime <= this.startTime && this.endTime <= other.endTime) return false ; //checks if this event is compelty inside the other event 
      }
      else return true; //self does not overlap 
    }
    return true ; //no overlap found
  }
}
  
  
  
  
  
