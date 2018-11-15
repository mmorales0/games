package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;

import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;
import box2D.collision.shapes.B2Shape;

import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;


/* ======================== Custom Import ========================= */
import box2D.dynamics.B2DebugDraw;
/* ================================================================ */



class Design_8_8_GameDebugger extends SceneScript
{
	public var _Enabled:Bool;
	public var _StepSize:Float;
	public var _StrokeThickness:Float;
	public var _XCenterOnScreen:Float;
	public var _YCenterOnScreen:Float;
	public var _DrawOrientation:Bool;
	public var _DrawVelocity:Bool;
	public var _Text:String;
	public var _ActorIDXOffset:Float;
	public var _ActorIDYOffset:Float;
	public var _DrawActorIDs:Bool;
	public var _ExcludeLightweightActors:Bool;
	public var _MouseasSceneCoordinates:Bool;
	public var _MouseXOffset:Float;
	public var _MouseYOffset:Float;
	public var _DrawMousePosition:Bool;
	public var _ToggleControl:String;
	public var _IncreaseGameSpeedControl:String;
	public var _DecreaseGameSpeedControl:String;
	public var _Font:Font;
	public var _VelocityColor:Int;
	public var _CustomColor:Int;
	public var _DrawShapes:Bool;
	public var _DrawJoints:Bool;
	public var _DrawAxisAlignedBoundingBoxes:Bool;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_Enable():Void
	{
		enableDebugDrawing();
		if(!Engine.NO_PHYSICS)
		{
			Engine.debugDrawer.setLineThickness(_StrokeThickness);
			var flags:Int = 0;
			if(_DrawShapes)
			{
				flags = flags | B2DebugDraw.e_shapeBit;
			}
			if(_DrawJoints)
			{
				flags = flags | B2DebugDraw.e_jointBit;
			}
			if(_DrawAxisAlignedBoundingBoxes)
			{
				flags = flags | B2DebugDraw.e_aabbBit;
			}
			if(_DrawOrientation)
			{
				flags = flags | B2DebugDraw.e_centerOfMassBit;
			}
			Engine.debugDrawer.setFlags(flags);
		}
	}
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("Enabled", "_Enabled");
		_Enabled = true;
		nameMap.set("Step Size", "_StepSize");
		_StepSize = 0.0;
		nameMap.set("Stroke Thickness", "_StrokeThickness");
		_StrokeThickness = 2.0;
		nameMap.set("X Center On Screen", "_XCenterOnScreen");
		_XCenterOnScreen = 0.0;
		nameMap.set("Y Center On Screen", "_YCenterOnScreen");
		_YCenterOnScreen = 0.0;
		nameMap.set("Draw Orientation", "_DrawOrientation");
		_DrawOrientation = true;
		nameMap.set("Draw Velocity", "_DrawVelocity");
		_DrawVelocity = true;
		nameMap.set("Text", "_Text");
		_Text = "";
		nameMap.set("Actor ID X-Offset", "_ActorIDXOffset");
		_ActorIDXOffset = 0.0;
		nameMap.set("Actor ID Y-Offset", "_ActorIDYOffset");
		_ActorIDYOffset = 32.0;
		nameMap.set("Draw Actor IDs", "_DrawActorIDs");
		_DrawActorIDs = false;
		nameMap.set("Exclude Lightweight Actors", "_ExcludeLightweightActors");
		_ExcludeLightweightActors = true;
		nameMap.set("Mouse as Scene Coordinates", "_MouseasSceneCoordinates");
		_MouseasSceneCoordinates = false;
		nameMap.set("Mouse X-Offset", "_MouseXOffset");
		_MouseXOffset = 8.0;
		nameMap.set("Mouse Y-Offset", "_MouseYOffset");
		_MouseYOffset = 0.0;
		nameMap.set("Draw Mouse Position", "_DrawMousePosition");
		_DrawMousePosition = false;
		nameMap.set("Toggle Control", "_ToggleControl");
		nameMap.set("Increase Game Speed Control", "_IncreaseGameSpeedControl");
		nameMap.set("Decrease Game Speed Control", "_DecreaseGameSpeedControl");
		nameMap.set("Font", "_Font");
		nameMap.set("Velocity Color", "_VelocityColor");
		_VelocityColor = Utils.getColorRGB(0,128,0);
		nameMap.set("Custom Color", "_CustomColor");
		_CustomColor = Utils.getColorRGB(0,0,128);
		nameMap.set("Draw Shapes", "_DrawShapes");
		_DrawShapes = true;
		nameMap.set("Draw Joints", "_DrawJoints");
		_DrawJoints = true;
		nameMap.set("Draw Axis-Aligned Bounding Boxes", "_DrawAxisAlignedBoundingBoxes");
		_DrawAxisAlignedBoundingBoxes = false;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_StepSize = asNumber(10);
		propertyChanged("_StepSize", _StepSize);
		if(_Enabled)
		{
			_customEvent_Enable();
		}
		else
		{
			disableDebugDrawing();
		}
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(_Enabled)
				{
					if((hasValue(_Font)))
					{
						g.setFont(_Font);
					}
					g.translateToScreen();
					if((_DrawOrientation || (_DrawVelocity || _DrawActorIDs)))
					{
						engine.allActors.reuseIterator = false;
						for(actorOnScreen in engine.allActors)
						{
							if(actorOnScreen != null && !actorOnScreen.dead && !actorOnScreen.recycled && actorOnScreen.isOnScreenCache)
							{
								if(!((_ExcludeLightweightActors && actorOnScreen.physicsMode > 0)))
								{
									g.strokeSize = Std.int(_StrokeThickness);
									_XCenterOnScreen = asNumber((actorOnScreen.getXCenter() - getScreenX()));
									propertyChanged("_XCenterOnScreen", _XCenterOnScreen);
									_YCenterOnScreen = asNumber((actorOnScreen.getYCenter() - getScreenY()));
									propertyChanged("_YCenterOnScreen", _YCenterOnScreen);
									if(_DrawVelocity)
									{
										g.strokeColor = _VelocityColor;
										g.drawLine(_XCenterOnScreen, _YCenterOnScreen, (_XCenterOnScreen + actorOnScreen.getXVelocity()), (_YCenterOnScreen + actorOnScreen.getYVelocity()));
									}
									if(_DrawActorIDs)
									{
										_Text = (("" + ("" + actorOnScreen.getType())) + ("" + (("" + " (") + ("" + (("" + ("" + actorOnScreen.ID)) + ("" + ")"))))));
										propertyChanged("_Text", _Text);
										g.drawString("" + _Text, ((_XCenterOnScreen - (g.font.font.getTextWidth(_Text)/Engine.SCALE / 2)) + _ActorIDXOffset), ((_YCenterOnScreen - (g.font.getHeight()/Engine.SCALE / 2)) + _ActorIDYOffset));
									}
								}
							}
						}
						engine.allActors.reuseIterator = true;
					}
					if((_DrawMousePosition && (!(#if mobile true #else false #end) || isMouseDown())))
					{
						if(_MouseasSceneCoordinates)
						{
							_Text = (("" + "(") + ("" + (("" + ("" + (getScreenX() + getMouseX()))) + ("" + (("" + ", ") + ("" + (("" + ("" + (getScreenY() + getMouseY()))) + ("" + ")"))))))));
							propertyChanged("_Text", _Text);
						}
						else
						{
							_Text = (("" + "(") + ("" + (("" + ("" + getMouseX())) + ("" + (("" + ", ") + ("" + (("" + ("" + getMouseY())) + ("" + ")"))))))));
							propertyChanged("_Text", _Text);
						}
						g.drawString("" + _Text, (getMouseX() + _MouseXOffset), (getMouseY() + _MouseYOffset));
					}
				}
			}
		});
		
		/* =========================== Keyboard =========================== */
		addKeyStateListener(_ToggleControl, function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && released)
			{
				_Enabled = !(_Enabled);
				propertyChanged("_Enabled", _Enabled);
				if(_Enabled)
				{
					_customEvent_Enable();
				}
				else
				{
					disableDebugDrawing();
				}
			}
		});
		
		/* =========================== Keyboard =========================== */
		addKeyStateListener(_IncreaseGameSpeedControl, function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && released)
			{
				_StepSize = asNumber(Math.max((_StepSize - 1), 1));
				propertyChanged("_StepSize", _StepSize);
				Engine.STEP_SIZE = Std.int(_StepSize);
				trace("" + (("" + "Step Size: ") + ("" + _StepSize)));
			}
		});
		
		/* =========================== Keyboard =========================== */
		addKeyStateListener(_DecreaseGameSpeedControl, function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && released)
			{
				_StepSize = asNumber((_StepSize + 1));
				propertyChanged("_StepSize", _StepSize);
				Engine.STEP_SIZE = Std.int(_StepSize);
				trace("" + (("" + "Step Size: ") + ("" + _StepSize)));
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}