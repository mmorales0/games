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



class ActorEvents_1 extends ActorScript
{
	public var _MaxHealth:Float;
	public var _EHealth:Float;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Max Health", "_MaxHealth");
		_MaxHealth = 100.0;
		nameMap.set("EHealth", "_EHealth");
		_EHealth = 50.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		engine.cameraFollow(actor);
		Engine.engine.setGameAttribute("health", _MaxHealth);
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				engine.cameraFollow(actor);
				if(isKeyDown("right"))
				{
					actor.setXVelocity(30);
				}
				else if(isKeyDown("left"))
				{
					actor.setXVelocity(-30);
				}
				else
				{
					actor.setXVelocity(0);
				}
				if(isKeyDown("down"))
				{
					actor.setYVelocity(30);
				}
				else if(isKeyDown("up"))
				{
					actor.setYVelocity(-30);
				}
				else
				{
					actor.setYVelocity(0);
				}
			}
		});
		
		/* =========================== Keyboard =========================== */
		addKeyStateListener("enter", function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && pressed)
			{
				createRecycledActor(getActorType(28), actor.getX(), actor.getY(), Script.FRONT);
				if(((actor.getAnimation() == "Walking Right") || (actor.getAnimation() == "Facing Right")))
				{
					getLastCreatedActor().setAnimation("" + "AA Right");
					getLastCreatedActor().applyImpulse(1, 0, 10);
				}
				else if(((actor.getAnimation() == "Walking Up") || (actor.getAnimation() == "Facing Up")))
				{
					getLastCreatedActor().setAnimation("" + "AA Up");
					getLastCreatedActor().applyImpulse(0, -1, 10);
				}
				else if(((actor.getAnimation() == "Walking Left") || (actor.getAnimation() == "Facing Left")))
				{
					getLastCreatedActor().setAnimation("" + "AA Left");
					getLastCreatedActor().applyImpulse(-1, 0, 10);
				}
				else if(((actor.getAnimation() == "Walking Down") || (actor.getAnimation() == "Facing Down")))
				{
					getLastCreatedActor().setAnimation("" + "AA Down");
					getLastCreatedActor().applyImpulse(0, 1, 10);
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(26), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(!((Engine.engine.getGameAttribute("health") == _MaxHealth)))
				{
					recycleActor(event.otherActor);
					if((Engine.engine.getGameAttribute("health") <= (_MaxHealth - Engine.engine.getGameAttribute("Red Potion Strength"))))
					{
						Engine.engine.setGameAttribute("health", (Engine.engine.getGameAttribute("health") + Engine.engine.getGameAttribute("Red Potion Strength")));
					}
					else
					{
						Engine.engine.setGameAttribute("health", _MaxHealth);
					}
				}
			}
		});
		
		/* ======================= Member of Group ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorGroup(4),event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if((Engine.engine.getGameAttribute("health") == _MaxHealth))
				{
					Engine.engine.setGameAttribute("health", (Engine.engine.getGameAttribute("health") - Engine.engine.getGameAttribute("EAttack")));
				}
				if((Engine.engine.getGameAttribute("health") <= (_MaxHealth - (3 * Engine.engine.getGameAttribute("EAttack")))))
				{
					recycleActor(event.thisActor);
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(24), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(!((Engine.engine.getGameAttribute("health") == _MaxHealth)))
				{
					recycleActor(event.otherActor);
					Engine.engine.setGameAttribute("health", _MaxHealth);
				}
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				Engine.engine.setGameAttribute("MC X", actor.getX());
				Engine.engine.setGameAttribute("MC Y", actor.getY());
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((actor.getX() < 0))
				{
					actor.setX(1);
				}
				else if((actor.getX() > ((getSceneWidth()) - (actor.getWidth()))))
				{
					actor.setX((((getSceneWidth()) - (actor.getWidth())) - -1));
				}
				if((actor.getY() < 0))
				{
					actor.setY(1);
				}
				else if((actor.getY() > ((getSceneHeight()) - (actor.getHeight()))))
				{
					actor.setY((((getSceneHeight()) - (actor.getHeight())) - -1));
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}