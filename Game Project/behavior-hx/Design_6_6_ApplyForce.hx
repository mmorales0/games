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



class Design_6_6_ApplyForce extends ActorScript
{
	public var _DownControl:String;
	public var _LeftControl:String;
	public var _RightControl:String;
	public var _X:Float;
	public var _Y:Float;
	public var _Force:Float;
	public var _Radius:Float;
	public var _Mode:String;
	public var _UpControl:String;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Down Control", "_DownControl");
		nameMap.set("Actor", "actor");
		nameMap.set("Left Control", "_LeftControl");
		nameMap.set("Right Control", "_RightControl");
		nameMap.set("X", "_X");
		_X = 0.0;
		nameMap.set("Y", "_Y");
		_Y = 0.0;
		nameMap.set("Force", "_Force");
		_Force = 10.0;
		nameMap.set("Radius", "_Radius");
		_Radius = 0.0;
		nameMap.set("Mode", "_Mode");
		_Mode = "";
		nameMap.set("Up Control", "_UpControl");
		
	}
	
	override public function init()
	{
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				_X = asNumber((asNumber(isKeyDown(_RightControl)) - asNumber(isKeyDown(_LeftControl))));
				propertyChanged("_X", _X);
				_Y = asNumber((asNumber(isKeyDown(_DownControl)) - asNumber(isKeyDown(_UpControl))));
				propertyChanged("_Y", _Y);
				if(!(((_X == 0) && (_Y == 0))))
				{
					if((_Mode == "Gradually"))
					{
						actor.push(_X, _Y, _Force);
					}
					else if((_Mode == "Instantly"))
					{
						actor.applyImpulse(_X, _Y, _Force);
					}
				}
			}
		});
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((sceneHasBehavior("Game Debugger") && asBoolean(getValueForScene("Game Debugger", "_Enabled"))))
				{
					if(!(((_X == 0) && (_Y == 0))))
					{
						g.strokeColor = getValueForScene("Game Debugger", "_CustomColor");
						g.strokeSize = Std.int(getValueForScene("Game Debugger", "_StrokeThickness"));
						_Radius = asNumber(Math.sqrt((Math.pow(_X, 2) + Math.pow(_Y, 2))));
						propertyChanged("_Radius", _Radius);
						g.drawLine(((actor.getWidth()/2) - (_Force * (_X / _Radius))), ((actor.getHeight()/2) - (_Force * (_Y / _Radius))), (actor.getWidth()/2), (actor.getHeight()/2));
					}
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}