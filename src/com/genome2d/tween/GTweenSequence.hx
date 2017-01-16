package com.genome2d.tween;

import com.genome2d.ui.element.GUIElement;
import com.genome2d.proto.GPrototypeFactory;
import com.genome2d.proto.IGPrototypable;
import com.genome2d.proto.GPrototypeExtras;
import com.genome2d.proto.GPrototype;
import com.genome2d.callbacks.GCallback.GCallback0;

@prototypeName("tweenSequence")
@:access(com.genome2d.tween.GTween)
@:access(com.genome2d.tween.GTweenStep)
class GTweenSequence implements IGPrototypable {
    private var g2d_poolNext:GTweenSequence;
    static private var g2d_poolFirst:GTweenSequence;
    static public function getPoolInstance():GTweenSequence {
        var sequence:GTweenSequence = null;
        if (g2d_poolFirst == null) {
            sequence = new GTweenSequence();
        } else {
            sequence = g2d_poolFirst;
            g2d_poolFirst = g2d_poolFirst.g2d_poolNext;
            sequence.g2d_poolNext = null;
        }

        return sequence;
    }

    private var g2d_next:GTweenSequence;
    private var g2d_firstStep:GTweenStep;
    private var g2d_currentStep:GTweenStep;
    private var g2d_lastStep:GTweenStep;
    public function getLastStep():GTweenStep {
        return g2d_lastStep;
    }

    private var g2d_stepCount:Int = 0;

    private var g2d_running:Bool = false;

    private var g2d_currentRepeat:Int = 0;

    public var repeatCount:Int = 0;

    private var g2d_complete:Bool;
    inline public function isComplete():Bool {
        return g2d_complete;
    }

    public function new() {
    }

    inline private function dispose():Void {
        g2d_currentStep = null;
        g2d_lastStep = null;
        g2d_stepCount = 0;
        g2d_complete = false;

        g2d_poolNext = g2d_poolFirst;
        g2d_poolFirst = this;
    }

    public function update(p_delta:Float):Void {
        if (g2d_complete || !g2d_running) return;

        if (g2d_currentStep == null) {
            if (++g2d_currentRepeat<repeatCount || repeatCount == 0) {
                g2d_currentStep = g2d_firstStep;
                update(p_delta);
            } else {
                finish();
            }
        } else {
            var rest:Float = g2d_currentStep.update(p_delta);
            if (rest>0) update(rest);
        }
    }

    inline private function finish():Void {
        GTween.g2d_dirty = true;
        g2d_complete = true;
    }

    inline private function addStep(p_tween:GTweenStep):GTweenStep {
        p_tween.g2d_sequence = this;

        if (g2d_currentStep == null) {
            g2d_firstStep = g2d_lastStep = g2d_currentStep = p_tween;
        } else {
            g2d_lastStep.g2d_next = p_tween;
            p_tween.g2d_previous = g2d_lastStep;
            g2d_lastStep = p_tween;
        }
        g2d_stepCount++;
        return p_tween;
    }

    inline private function addSequence(p_sequence:GTweenSequence):GTweenSequence {
        g2d_next = p_sequence;
        return g2d_next;
    }

    inline private function nextStep():Void {
        g2d_currentStep = g2d_currentStep.g2d_next;
    }

    inline private function removeStep(p_tween:GTweenStep):Void {
        g2d_stepCount--;
        if (g2d_firstStep == p_tween) g2d_firstStep = g2d_firstStep.g2d_next;
        if (g2d_currentStep == p_tween) g2d_currentStep = p_tween.g2d_next;
        if (g2d_lastStep == p_tween) g2d_lastStep = p_tween.g2d_previous;
        if (p_tween.g2d_previous != null) p_tween.g2d_previous.g2d_next = p_tween.g2d_next;
        if (p_tween.g2d_next != null) p_tween.g2d_next.g2d_previous = p_tween.g2d_previous;
    }

    public function skipCurrent() {
        if (g2d_currentStep != null) g2d_currentStep.skip();
    }

    public function bind(p_target:GUIElement, p_autoRun:Bool = false):Void {
        var step:GTweenStep = g2d_firstStep;
        while (step != null) {
            if (step.targetId != null) {
                step.g2d_target = p_target.getChildByName(step.targetId, true);
            }
            step = step.g2d_next;
        }
        run();
    }

    public function run():Void {
        g2d_running = true;
    }

    /****************************************************************************************************
	 * 	PROTOTYPE CODE
	 ****************************************************************************************************/

    public function getPrototype(p_prototype:GPrototype = null):GPrototype {
        p_prototype = getPrototypeDefault(p_prototype);

        var step:GTweenStep = g2d_firstStep;
        while (step != null) {
            p_prototype.addChild(step.getPrototype(), "tweenSteps");
            step = step.g2d_next;
        }

        return p_prototype;
    }

    public function bindPrototype(p_prototype:GPrototype):Void {
        bindPrototypeDefault(p_prototype);

        var stepPrototypes:Array<GPrototype> = p_prototype.getGroup("tweenSteps");
        if (stepPrototypes != null) {
            for (stepPrototype in stepPrototypes) {
                var step:GTweenStep = GPrototypeFactory.createInstance(stepPrototype);
                addStep(step);
            }
        }
    }
}
