//let's build a goddamn room
//use a matrix!!
#include "colors.inc"
#include "textures.inc"
#include "shapes.inc"
#include "finish.inc"


global_settings {
 
  radiosity {
    pretrace_start 0.08           // start pretrace at this size
    pretrace_end   0.04           // end pretrace at this size
    count 100                // higher -> higher quality (1..1600) [35]

    nearest_count 5              // higher -> higher quality (1..10) [5]
    error_bound 1.8               // higher -> smoother, less accurate [1.8]
    recursion_limit 3             // how much interreflections are calculated (1..5+) [3]

    low_error_factor .5           // reduce error_bound during last pretrace step
    gray_threshold 0.0            // increase for weakening colors (0..1) [0]
    minimum_reuse 0.15           // reuse of old radiosity samples [0.015]
    brightness 1                  // brightness of radiosity effects (0..1) [1]

    adc_bailout 0.01/2
    normal on                   // take surface normals into account [off]
    media on                    // take media into account [off]
  
  }
  
}

#declare WoodColorMap = color_map {
	[0.0 Flesh*1.7]
	[0.8 Tan*1.5 ]
	[1 LightWood*1.7]
}
	
#declare DarkWoodMap = color_map{
	[0.0 DustyRose*.1]
	[0.01 DarkTan*.05]
	[0.7 Firebrick*.1]
	[1 Firebrick*.2]
}
	
#declare WoodPigment = pigment {
	wood 
	color_map {WoodColorMap}	
	turbulence .5 //creates more uneven grain 
	scale <14,70,1> //scale on y to create more woodlike shape
}

#declare DarkWoodPigment=pigment {
	color Firebrick*.1
	}


//put the #declare bits here!——————————————————————————————————————————————————————
#declare WallPaper= texture {
		pigment {
			MediumForestGreen}
		}
//basic room construction
#declare RoomLength= 100;
#declare RoomWidth =100;
#declare RoomHeight=(RoomLength/3)*2;
#declare Room=box {
	<0,0,0>
	<RoomWidth, RoomHeight, RoomLength>
	texture {WallPaper	}
	hollow
}

#declare HalfRoomLength= .5*RoomLength;
#declare HalfRoomWidth= .5*RoomWidth;
#declare HalfRoomHeight = .5*RoomHeight;

#declare DoorHeight=HalfRoomHeight+15;
#declare DoorWidth=DoorHeight/2;
#declare DoorToRightWall=30;
#declare DoorDepth=3;
#declare DoorOutline= box {
	<0,0,-DoorDepth>
	<DoorWidth,DoorHeight,DoorDepth>
	
};
#declare DoorCutOut=box{
	<3,DoorHeight-3,-DoorDepth-1>
	<DoorWidth,DoorHeight-DoorHeight*1/2,DoorDepth+1>

}

#declare Door=difference{
	object{DoorOutline}
	object{DoorCutOut}
	

}
	

object{Door
	texture{
		pigment{DarkWoodPigment}
	}
	translate <RoomWidth-DoorToRightWall,0,RoomLength>
}


//floor
#declare Flooring = pigment {
	rgb <1,1,1> }

//window1
#declare WindowRadius=15;
#declare WindowHeightFromFloor =(2/3)*RoomHeight;
#declare WindowDistanceFromCorner = 40;
#declare WindowCutOut1= sphere{
	<0,0,0>
	WindowRadius
	translate <WindowDistanceFromCorner, WindowHeightFromFloor, 0>
}

//windowframe
#declare WindowRim= difference{
		cylinder{
		<0,0,1>
		<0,0,-1>
		WindowRadius}
		
		cylinder{
		<0,0,2>
		<0,0,-2>
		WindowRadius-1.4
		}
		
}

#declare crossbar= box{
	<0,0,0>
	<1,WindowRadius*2,1>
}

#declare WindowFrame=union{
	object{WindowRim}
	object{crossbar
		translate <0,-WindowRadius,0>}
	object{crossbar
		rotate<0,0,90>
		translate<WindowRadius,0,0>
	}
}	
	
object{WindowFrame
	translate <WindowDistanceFromCorner,WindowHeightFromFloor,0>
	texture{
		DarkWoodPigment
	}
}
#declare GlassTexture=texture{
		pigment{
			rgbf<.7,.9,.7,.8>
		}
		finish { irid {.5 thickness .1 turbulence 10}}
	

	}
	texture{
		normal {waves 10}
		scale 10
		pigment{
			rgbf<1,1,1,.99>
		}
		finish{ reflection .4}
			}

#declare WindowGlass=cylinder{
	<0,0,0>
	<0,0,-1>
	WindowRadius
	texture {GlassTexture}
	}

object{WindowGlass
	translate <WindowDistanceFromCorner,WindowHeightFromFloor,0>
	}

#declare DoorGlass= box{
	<3,DoorHeight-3,DoorDepth>
	<DoorWidth,DoorHeight-DoorHeight*1/2,DoorDepth+.1>
	texture{GlassTexture}
}

object{DoorGlass
	translate <RoomWidth-DoorToRightWall,0,RoomLength>
}	

	
	

sky_sphere {
    pigment {
    		rgb<0,0,1>
    }
    	pigment{
    		bozo
    		turbulence .65
    		omega .63
    		lambda 2
    		color_map{ 
    			[0.0 0.1 color rgb <0.85, 0.85, 0.85>
                   color rgb <0.75, 0.75, 0.75>]
          [0.1 0.5 color rgb <0.75, 0.75, 0.75>
                   color rgbt <1, 1, 1, 1>]
          [0.5 1.0 color rgbt <1, 1, 1, 1>
                   color rgbt <1, 1, 1, 1>]				
    	}
    	
    scale <2,.5,2>
    	}
} 
    	
    	
    	
//here's where the functional parts go!——————————————————————————————————————————————————————


	
light_source {
	<HalfRoomWidth,RoomHeight-10,HalfRoomLength>
	rgb <1,1,1>*.1
	media_interaction off
}

light_source{
	<-30,100,30>
	rgb <1,1,.5>
	parallel	
	point_at <HalfRoomWidth,3,HalfRoomLength>
	media_interaction on
}

light_source{
	<RoomWidth-20,RoomHeight+10,RoomLength+50>
	rgb<1,1,.5>*.2
	spotlight
	point_at<RoomWidth-20,0,10>
	falloff 50
	tightness 10
	media_attenuation on
	}
	
	
	
light_source{
	<RoomWidth-40,RoomHeight+30,-RoomLength+20>	
	rgb<1,1,.7,>*.2
	spotlight
	point_at<WindowDistanceFromCorner,WindowHeightFromFloor,0>
	falloff 10
	tightness 10
	media_attenuation on
}



//camera bits
#declare DoorView= camera {
		location <10,HalfRoomHeight,10>
		look_at <RoomWidth-.1,HalfRoomHeight*1/8,RoomLength-5>
	focal_point <RoomWidth-.1,HalfRoomHeight*1/8,RoomLength-5>
	aperture .4
	blur_samples 10
	
}		

#declare OriginView= camera{
	location <RoomWidth-10,RoomHeight-20,RoomLength-10>
	look_at <0,0,16>
}

#declare ShelfCornerView=camera{
	location<HalfRoomWidth-40,HalfRoomHeight+10,HalfRoomLength-30>
	look_at<RoomWidth-1,HalfRoomHeight,HalfRoomLength>
}

#declare BedTimeView=camera{
	location<HalfRoomWidth+10,HalfRoomHeight+20,HalfRoomLength+15>
	look_at <0,0,0>
	focal_point <10,0,10>
	aperture .5
	blur_samples 10
}


#declare OutsideWindowView=camera{
	location <RoomWidth-40,RoomHeight+30,-RoomLength+20>
	look_at<WindowDistanceFromCorner,WindowHeightFromFloor,0>
	}

#declare OutsideDoorView=camera{
	location <RoomWidth-20,RoomHeight+15,RoomLength+60>
	look_at<RoomWidth-20,0,0>
	}

#declare PlantView=camera{
	location<HalfRoomWidth-30,RoomHeight-10,HalfRoomLength-10>
	look_at<RoomWidth,HalfRoomHeight,0>
}

#declare TableView=camera{
	location<HalfRoomWidth,HalfRoomHeight,60>
	look_at<WindowDistanceFromCorner,20,0>
}

#declare WindowView=camera{
	location<HalfRoomWidth,HalfRoomHeight+10,RoomLength-1>
	look_at<WindowDistanceFromCorner,WindowHeightFromFloor,0>
	angle 70
}

#declare BookShelfView=camera{
	location<10,RoomHeight-1,HalfRoomLength>
	look_at <RoomWidth, HalfRoomHeight,HalfRoomLength>
}

camera {DoorView}

/*needed: 
	5 camera positions
	1+ new angle
	1+ depth of field
	*/

//walls, ceilings, etc!——————————————————————————————————————————————

difference {
	object {
		Room
		scale 1.01
		}
	object {
		Room
	}
	object{DoorCutOut
		translate <RoomWidth-DoorToRightWall,0,RoomLength>
}

	object {
		WindowCutOut1
	}
}

//floor
box{
	<0,0,0>
	<RoomWidth,.001,RoomLength>
	texture {
		Flooring
	}
}

//furniture!!!!!!!!——————————————————————————————————————————————————————


//bed
#declare bedwidth=30;
#declare bedlength=50;
#declare bedheight=20;

#declare FrameBaseHeight=.5;
#declare FrameBase=box {
	<0,0,0>
	<bedwidth,FrameBaseHeight,bedlength>
	texture {
		pigment{
			WoodPigment
		}
	}
}

#declare BeddingTexture= pigment{
	color red 0.00 green 0.15 blue 0.85}
#declare BeddingColor= color red 0.00 green 0.15 blue 0.85;

#declare mattress=object {
	Round_Box (
	<0,0,0>
	<bedwidth-1,bedheight*1/3+2,bedlength-1>
	2
	0)
	translate <0,FrameBaseHeight-.5,0>
	texture{
			pigment{
				gradient z
				color_map{
					[0.0 rgb <1,1,1>*2]
					[0.3 rgb <1,1,1>]
					[1 color BeddingColor]}
				scale<0,0,50> 
	}				
}
}

//legs4days
#declare legwidth=5;
#declare leglength=1;
#declare frontleg=box{
	<0,0,0>
	<legwidth,bedheight+2,leglength>
}

#declare backleg= box{
	<0,0,0>
	<legwidth,bedheight+bedheight*.5,leglength>
	}

#declare headboard=box{
	<0,0,0>
	<bedwidth,bedheight*.5,leglength>
	}

#declare BedFrame=union{
	object{FrameBase}
	object{frontleg
	translate <bedwidth-legwidth,-bedheight*.5,bedlength>
	}
	
object{frontleg
	translate <0,-bedheight*.5,bedlength>
}

object{backleg
	translate <bedwidth-legwidth,-bedheight*.5,-leglength>}
	
object{backleg
	translate <0,-bedheight*.5,-leglength>
}

object{headboard 
	translate<0,bedheight*.5,-leglength>
	}
	texture{
		pigment{
			WoodPigment
		}
	}

}

#declare bed=	 union{ 
	object {BedFrame}

	object {mattress
				}
}

//sidetable


#declare tablewidth=25;
#declare TableHeight=7;
#declare tablelength=25;
#declare top=box{
	<0,TableHeight-1,0>
	<25,TableHeight,25>
	texture{
		pigment{
			WoodPigment
		}
		scale<.4,0,20>
			}
}

#declare singleleg=union{
	cone{
		<0,-TableHeight*1/3,0>
		.5
		<0,TableHeight-1,0>
		4}	
	cone{
		<0,-TableHeight*7/3,0>
		2
		<0,-TableHeight*1/3,0>
		.5
	}	
}

#declare sidetable= union{
	object {top}
	object{singleleg
	translate <tablewidth*.5,0,tablelength*.5>
	}
	translate <bedwidth+legwidth+.2,15,0>
	texture {DarkWoodPigment}
}


//desk

#declare deskwidth=25;
#declare deskheight=15;
#declare desklength=15;
#declare desktopheight=1;
#declare deskcolor=pigment{
	WoodPigment
	scale <0,0,10>
}

#declare Desktop=box{
	<0,0,0>
	<deskwidth,desktopheight,desklength>
	texture{
		deskcolor	
				
		
	}
}

#declare DeskBackPanel= box{
	<0,0,15>
	<deskwidth,-deskheight,desklength>
	texture{
		deskcolor	}

}

#declare Drawer1=box{
	<0+.6,0-desktopheight*1/2,0>
	<deskwidth*1/3-.2,-deskheight*1/2-.2,desklength*2/3-.2>
	texture{
		deskcolor
		translate <0,20,10>
		scale <0,2,0>
	}
}

#declare Drawer2=box{
	<0+.6,-deskheight*1/2-.5,0>
	<deskwidth*1/3,-deskheight+1,desklength*2/3>
	texture{
		deskcolor}
}

#declare Leg= box{
	<0,0,0>
	<.6,-deskheight,1>
	texture{
		deskcolor}
}
	
	
#declare desk=union{	
object{Leg}
object{Leg
	translate<0,0,desklength*2/3>
}	
object{Leg
	translate<deskwidth*1/3,0,0> 
}
object{Leg
	translate<deskwidth*1/3,0,desklength*2/3>
}
object{Leg
	translate<deskwidth-.6,0,0>
}

object {Desktop}
object {DeskBackPanel}
object {Drawer1}
object{Drawer2}
}

//shelf
#declare shelfwidth=50;
#declare shelfheight=1;
#declare shelflength=15;
#declare Shelf=box{
	<0,0,0>
	<shelfwidth,shelfheight,shelflength>
	texture{
		pigment{
			WoodPigment
		}
		scale<10,0,0>
	}
}


	
//Pillow
#declare PillowHeight=.85;
#declare HalfPillowHeight=PillowHeight*1/2;
#declare PillowLength=5;

#declare B11=<0,-HalfPillowHeight,3>; #declare B12=<PillowLength*1/3,-HalfPillowHeight,3>; //
#declare B13=<PillowLength,-HalfPillowHeight,3>; #declare B14=<PillowLength,-HalfPillowHeight,3>; // row 1

#declare B21=<0,-HalfPillowHeight,2>; #declare B22=<PillowLength*1/3,PillowHeight,2>; //
#declare B23=<PillowLength*2/3,PillowHeight,2>; #declare B24=<PillowLength,-HalfPillowHeight,2>; // row 2

#declare B31=<0,-HalfPillowHeight,1>; #declare B32=<PillowLength*1/3,PillowHeight,1>; //
#declare B33=<PillowLength*2/3,PillowHeight,1>; #declare B34=<PillowLength,-HalfPillowHeight,1>; // row 3

#declare B41=<0,-HalfPillowHeight,0>; #declare B42=<PillowLength*1/3,-HalfPillowHeight*1/2,0>; //
#declare B43=<PillowLength*2/3,-HalfPillowHeight,0>; #declare B44=<PillowLength,-HalfPillowHeight,0>; // row 4

#declare PillowHalf=bicubic_patch {
   type 1 flatness 0
   u_steps 4 v_steps 4
   uv_vectors
   <0,0> <1,0> <1,1> <0,1>
   B11, B12, B13, B14
   B21, B22, B23, B24
   B31, B32, B33, B34
   B41, B42, B43, B44
   uv_mapping
  texture{
  	pigment{
  		BeddingTexture}
  }
}

#declare TrimRadius=.1;
#declare PillowTrim= union{
	object{cylinder{
	<0,-HalfPillowHeight,0>
	<PillowLength,-HalfPillowHeight,0>
	TrimRadius
}
}
	object{cylinder{
	<0,-HalfPillowHeight,3>
	<0,-HalfPillowHeight,0>
	TrimRadius
}}
	object{ cylinder {
	<PillowLength,-HalfPillowHeight,3>
	<0,-HalfPillowHeight,3>
	TrimRadius}
}
	object{ cylinder{
	<PillowLength,-HalfPillowHeight,3>
	<PillowLength,-HalfPillowHeight,0>
	TrimRadius}
}
	object{sphere{
	<0,-HalfPillowHeight,0>
	TrimRadius
}
}
	object{sphere{
	<0,-HalfPillowHeight,3>
	TrimRadius
}}
	object{sphere{
	<PillowLength,-HalfPillowHeight,3>
	TrimRadius
}}
	object{sphere{
	<PillowLength,-HalfPillowHeight,0>
	TrimRadius
}}
texture{
		pigment{rgb <1,1,1>*1.5}
	}
}

#declare PillowBody=union{
	object{PillowHalf}
	
	object{PillowHalf
	rotate<-180,0,0>
	translate<0,-PillowHeight,3>}
	
	object{PillowTrim}	
}


//bedspread????

#declare TuckedIn= object {Round_Box(
	<0,0,0>
	<bedwidth+1, bedheight*1/2,bedlength*1/3>
	2
	0)
	texture{
		pigment{
			BeddingTexture}
		normal{ripples 2}
		scale 10
		rotate <0,90,0>
	}
}


//objects—————————————————————————————————————————
object{bed
	translate<legwidth,bedheight*.5,legwidth>
	
}	
object{sidetable
	scale<.8,.8,.8>
	translate<10,0,0>}
object{desk
	scale<1.3,1.3,1.3>
	translate<bedwidth,deskheight*1.3,RoomLength-desklength-6>}
	
object{Shelf
	rotate<0,90,0>
	translate <RoomWidth-shelflength,20,shelfwidth+10>
	
}


object{Shelf
	rotate <0,90,0>
	translate<RoomWidth-shelflength,35,shelfwidth+20>
}

object{Shelf
	rotate<0,90,0>
	translate<RoomWidth-shelflength,50,shelfwidth+30>
}


object{PillowBody
	
	rotate <18,0,1>
	translate <3,bedheight*1/3,leglength+TrimRadius*7.4>
	scale 3.7
}

object{TuckedIn
	translate<4,bedheight*1/3+3,leglength+bedlength*1/4>
	}
//Plant!!!////////——————————————————————————————————————————————————————
#declare PlantPotRadius=3;
#declare PlantPotHeight=5;

#declare TwigRadius=.5;

#declare PlantPot=lathe{
	linear_spline
   6,
    <0,0>, <PlantPotRadius-1,0>, <PlantPotRadius,PlantPotHeight>, <PlantPotRadius+.3,PlantPotHeight>, <PlantPotRadius+.3,PlantPotHeight-.5>, <0,PlantPotHeight-1>
    pigment { rgb <1,1,1>}
    finish {
      ambient .3
      phong .75
    }
}	


#declare stick=blob{
	threshold .2
	
	cylinder{
		<3,1,0>
		<7,4,0>
		.8
		1
	}

	cylinder{
		<7,4,0>
		<10,0,0>
		.6
		1
		}	
	cylinder{
		<10,0,0>
		<10,-1,1>
		.5
		1
	}
	cylinder{
		<10,-1,1>
		<10,-5,-1>
		.48
		1
	}
	cylinder{
		<10,-5,-1>
		<9.9,-10,1>
		.4
		1}
	cylinder {
		<9.9,-10,1>
		<9.8, -15,1>
		.3
		1}
}


#declare Leaf=mesh2{
	vertex_vectors{
		8		
		<0,0,-1>
		<1.5,1,0>
		<1.5,3,0>
		<1,2.5,0>
		<0,4.5,1>
		<-1,2.5,0>
		<-1.5,3,0>
		<-1.5,1,0>
	}
		face_indices{
		6

		<0,1,3>
		<1,2,3>
		<0,3,5>
		<3,5,4>
		<0,5,7>
		<5,7,6>
			}
	texture{
		pigment{
			rgb<0,1,0>}}

};


#declare SmallLeaf=object{
	Leaf
	scale.75}

#declare Foliage=union{



object{Leaf
	rotate<100,130,30>
	translate<7,3.5,0>}
object{Leaf
	rotate<130,150,30>
	translate<7.5,2.5,0>
}
object{Leaf
	rotate<130,0,30>
	translate<8,2,0>
}

object{Leaf
	rotate <90,100,-35>
	translate <9,.8,0>}

object{Leaf
	rotate <100,60,-30>
	translate<9.5,-2.5,0>}
object{Leaf
	rotate <90,140,-30>
	translate <9.5,-4,0>}
object{Leaf
	rotate<90,10,-30>
	translate<9,-7,-.5>
}
object{SmallLeaf
	rotate<90,100,-35>
	translate<9,-8,0>
}

object{SmallLeaf
	rotate<90,50,-30>
	translate<9,-8.5,.5>}


object{SmallLeaf
	rotate<90,100,-30>
	translate<9.5,-11,1>
}

}

#declare Branch=union{
object{Foliage}
object{stick}
}

#declare PlanterDistanceFromCeiling=20;
#declare PlanterString=cylinder{
	<PlantPotRadius-.5,PlantPotHeight,0>
	<0,PlanterDistanceFromCeiling,0>
	.04
}

#declare Plant=union{
	object{Branch
	scale.7
	rotate<0,-30,0>
	translate<-3,PlantPotHeight-2,0>}
	
object{Branch
	scale .5
	rotate<0,20,0>
	translate<-1.5,PlantPotHeight-1.5,-1>
}

object{Branch
	scale.3
	rotate<0,20,70>
	translate<0,PlantPotHeight-1.8,0>
}

object{Branch
	scale <.8,1,.8>
	translate<-4,PlantPotHeight-1.5,0>
}

object{SmallLeaf
	rotate<100,130,-30>
	scale .5
	translate<5,3,-2>
}

object{PlantPot}	

}

#declare HangingPlant=union{
	object{Plant
	scale 1.5}
	object{PlanterString}
	object{PlanterString
	rotate<0,180,0>
}
}

	

object{HangingPlant
	rotate <0,220,0>
	translate<80,RoomHeight-PlanterDistanceFromCeiling,10>

}

object{Plant
	rotate<0,-130,0>
	translate<86,36,HalfRoomLength+17.5>
}

//BOOK——————————————————————————————————————————————————
#declare BookHeight=10;
#declare BookWidth=2;
#declare BookLength=10;
#declare BindingPigment1=texture{
	pigment{  color rgb <0.1,0.3,1>*.09}
	normal {dents .8 scale .005}
	finish{ ambient .1  diffuse 1  roughness 2    phong .08 phong_size 30}
}

#declare BindingPigment2=texture{
  pigment {    color rgb <0.46, 0.02, 0.02>*.1  }
  normal {    dents 1 scale.00002  }
  finish {    ambient 0.3   diffuse 1    phong 0.08    phong_size 16
    roughness 5     }
}

#declare BindingPigment3=texture{
	pigment{color rgb <0.3, .51, .1>*.04}
	normal{ dents 1 scale .0003}
	finish{ ambient .1  diffuse 1  phong .03  phong_size 30 roughness 10 crand .03}
}

#declare Spine=Round_Box (
	<0,0,0>
	<BookWidth,BookHeight,.5>
	.4
	1
	)
	


#declare Pages=box{
	<.2,0,.5>
	<BookWidth-.2,BookHeight-.2,BookLength-.2>
	texture{
		pigment{
			rgb<1,1,1>
		}
	}
}



#declare FrontCover=box{
	<0,0,.2>
	<.2,BookHeight,BookLength>
	
}



#declare BackCover=box{
	<BookWidth-.2,0,.2>
	<BookWidth,BookHeight,BookLength>
	
}

#declare Cover=union{
	object{FrontCover}
	object{BackCover}
	object{Spine}
}

#declare Book1=union{
	object{Cover
	}
	object{Pages}
	scale<0,1.3,0>
	}
#declare Book2=union{
	object{Cover
		
	}
	object{Pages}
	scale 1.1
}

#declare Book3=union{
	object{Cover
		}
	object{Pages}
	scale <2, 1.2,0>
	}
#declare BooksOnShelf= union{
object{Book1
	rotate<0,90,0>
	translate<RoomWidth-BookLength*1.5,36,HalfRoomLength-10.5>
	texture{BindingPigment2}
}

object{Book2
	rotate <0,90,0>
	translate <RoomWidth-BookLength*1.5,36,HalfRoomLength-13>
	texture{BindingPigment1}
}

object{Book2
	rotate<0,0,10>
	rotate<0,90,0>
	translate <RoomWidth-BookLength*1.5,36,HalfRoomLength-17>
	texture{BindingPigment2}
}

object{Book2

	rotate<0,90,0>
	translate<RoomWidth-BookLength*1.2,36,HalfRoomLength-8>
	texture{BindingPigment2}
}

object{Book3
	rotate <0,90,0>
	translate<RoomWidth-BookLength*1.5,36,HalfRoomLength-3>
	texture{BindingPigment3}
}

object{Book2
	rotate<0,90,0>
	translate<RoomWidth-BookLength*1.3,36,HalfRoomLength-19>
	texture{BindingPigment3}
}

object{Book1
	rotate<0,90,0>
	translate<RoomWidth-BookLength*1.3,36,HalfRoomLength-22>
	texture{BindingPigment1}
}

object{Book1
	rotate<10,0,30>
	rotate<0,90,0>
	translate<RoomWidth-BookLength*1,36,HalfRoomLength-30.4>
	texture{BindingPigment3}
}

object{Book3
	rotate<20,0,90>
	rotate<0,90,0>
	translate<RoomWidth-BookLength*2,51,HalfRoomLength-10>
	texture{BindingPigment2}
}
}

object{BooksOnShelf
	translate <0,0,10>}

object{Book2
	rotate <0,0,90>
	rotate<0,45,0>
	texture{BindingPigment3}
	translate <50,TableHeight*2+3.6,5>
}

//Cup——————————————————————————————————————————————————

#declare Cup = lathe{
		quadratic_spline
			11,
		<0,0>, <.5,.5>, <1,2>,<1.1,2>,<.6,.5>,<.3,0>,<.2,-.5>	,<.1,-.7>,<.2,-1>,<.6,-1.3>,<.6,-1.5>		texture{GlassTexture}
		texture{
			
			finish{reflection .5 phong 10}
		}
}
			
		
object{Cup
	scale 2
	translate <HalfRoomWidth-8,TableHeight*2+7,6>}

	
	
//DustMotes——————————————————————————————————————————————

#declare Dust=box{
	//<RoomWidth-.1,RoomHeight-.1,RoomLength-.1>
	//<.1,.1,.1>
	<0.1,0.1,0.1>
	<1,1,1>
	texture{pigment{rgbt 1}}
	hollow 
	interior{
		media{
			scattering {2, 0.02 extinction .1}
			samples 30,100}
	}
}
	
object{Dust
	scale 101
	translate<0,-1,0>
	}
	




