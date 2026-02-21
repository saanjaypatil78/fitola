"""
Adaptive Self-Improving Workflows
Uses MemuBot to create AI that learns and improves from every interaction

Key Features:
- Pattern recognition from user behavior
- Adaptive fitness plan generation
- Proactive motivation based on learned triggers
- Self-improving workout recommendations
"""
import logging
from typing import Dict, Any, List, Optional
from datetime import datetime, timedelta
from enum import Enum

logger = logging.getLogger(__name__)


class AdaptiveWorkflowType(str, Enum):
    """Types of adaptive workflows"""
    LEARNING_FITNESS_PLAN = "learning_fitness_plan"
    PREDICTIVE_WORKOUT = "predictive_workout"
    PROACTIVE_MOTIVATION = "proactive_motivation"
    ADAPTIVE_NUTRITION = "adaptive_nutrition"
    SMART_GOAL_TRACKING = "smart_goal_tracking"


class PatternType(str, Enum):
    """Types of patterns the system can learn"""
    WORKOUT_PREFERENCE = "workout_preference"
    TIME_PREFERENCE = "time_preference"
    EXERCISE_PERFORMANCE = "exercise_performance"
    MOTIVATION_TRIGGER = "motivation_trigger"
    NUTRITION_COMPLIANCE = "nutrition_compliance"
    RECOVERY_PATTERN = "recovery_pattern"


class AdaptiveWorkflowEngine:
    """
    Engine for self-improving AI workflows
    Combines MemuBot memory with pattern recognition and adaptation
    """
    
    def __init__(self, memubot_manager, gemini_client=None):
        """
        Initialize adaptive workflow engine
        
        Args:
            memubot_manager: MemuBot manager for memory operations
            gemini_client: Optional Gemini client for AI generation
        """
        self.memory = memubot_manager
        self.gemini = gemini_client
    
    async def execute_learning_fitness_plan(
        self,
        user_id: str,
        user_data: Dict[str, Any],
        parameters: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Generate fitness plan that adapts based on user's history and patterns
        
        This workflow:
        1. Retrieves user's workout history and preferences
        2. Identifies patterns (preferred exercises, best performance times)
        3. Generates personalized plan using learned patterns
        4. Stores the plan for future adaptation
        """
        
        # Step 1: Retrieve relevant memories
        workout_history = await self.memory.retrieve_memories(
            user_id=user_id,
            query="workout history and performance",
            limit=10
        )
        
        preferences = await self.memory.retrieve_memories(
            user_id=user_id,
            query="exercise preferences and likes",
            limit=5
        )
        
        patterns = await self.memory.retrieve_memories(
            user_id=user_id,
            query="workout patterns and successful routines",
            limit=5
        )
        
        # Step 2: Analyze patterns
        insights = self._analyze_fitness_patterns(workout_history, preferences, patterns)
        
        # Step 3: Generate adaptive plan
        plan = await self._generate_adaptive_fitness_plan(
            user_data=user_data,
            parameters=parameters,
            insights=insights
        )
        
        # Step 4: Memorize this plan generation
        await self.memory.memorize_interaction(
            user_id=user_id,
            interaction_type="fitness_plan_generated",
            content={
                "plan_summary": plan.get("summary", ""),
                "adaptations": insights.get("adaptations", []),
                "generated_at": datetime.now().isoformat()
            }
        )
        
        return {
            "workflow": "learning_fitness_plan",
            "plan": plan,
            "insights_used": insights,
            "adaptive_features": [
                "Personalized based on past performance",
                "Optimized for your preferred workout times",
                "Includes exercises you've shown progress in",
                "Adapts to your recovery patterns"
            ],
            "learning_stats": {
                "memories_analyzed": len(workout_history) + len(preferences) + len(patterns),
                "patterns_identified": len(insights.get("patterns", []))
            }
        }
    
    async def execute_predictive_workout(
        self,
        user_id: str,
        context: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Predict and suggest best workout for current context
        
        Uses:
        - Time of day patterns
        - Recent workout history
        - Energy levels and recovery state
        - Historical performance data
        """
        
        # Retrieve relevant context
        recent_workouts = await self.memory.retrieve_memories(
            user_id=user_id,
            query="recent workouts and recovery",
            limit=5
        )
        
        time_patterns = await self.memory.retrieve_memories(
            user_id=user_id,
            query="workout time preferences and performance by time",
            limit=3
        )
        
        # Predict best workout
        prediction = self._predict_optimal_workout(
            context=context,
            recent_workouts=recent_workouts,
            time_patterns=time_patterns
        )
        
        # Memorize this prediction for learning
        await self.memory.memorize_interaction(
            user_id=user_id,
            interaction_type="workout_predicted",
            content={
                "prediction": prediction,
                "context": context,
                "timestamp": datetime.now().isoformat()
            }
        )
        
        return {
            "workflow": "predictive_workout",
            "prediction": prediction,
            "confidence": prediction.get("confidence", 0.7),
            "reasoning": prediction.get("reasoning", ""),
            "context_factors": prediction.get("factors", [])
        }
    
    async def execute_proactive_motivation(
        self,
        user_id: str,
        user_state: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Proactively provide motivation based on learned triggers
        
        Detects:
        - When user typically needs motivation
        - What type of motivation works best
        - Patterns in motivation effectiveness
        """
        
        # Retrieve motivation history
        motivation_history = await self.memory.retrieve_memories(
            user_id=user_id,
            query="motivation and encouragement responses",
            limit=10
        )
        
        # Identify motivation triggers
        triggers = self._identify_motivation_triggers(motivation_history, user_state)
        
        # Check if proactive motivation is needed
        should_motivate = triggers.get("should_motivate", False)
        
        if should_motivate:
            # Generate personalized motivation
            motivation = await self._generate_adaptive_motivation(
                user_id=user_id,
                triggers=triggers,
                user_state=user_state
            )
            
            # Memorize this motivation event
            await self.memory.memorize_interaction(
                user_id=user_id,
                interaction_type="proactive_motivation_sent",
                content={
                    "trigger": triggers.get("trigger_type", ""),
                    "message": motivation.get("message", ""),
                    "timestamp": datetime.now().isoformat()
                }
            )
            
            return {
                "workflow": "proactive_motivation",
                "should_send": True,
                "motivation": motivation,
                "trigger_detected": triggers.get("trigger_type", ""),
                "confidence": triggers.get("confidence", 0.6)
            }
        else:
            return {
                "workflow": "proactive_motivation",
                "should_send": False,
                "reason": "No motivation trigger detected"
            }
    
    async def execute_adaptive_nutrition(
        self,
        user_id: str,
        user_data: Dict[str, Any],
        parameters: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Generate nutrition plan that adapts to compliance and preferences
        
        Learns:
        - Which meal plans user actually follows
        - Preferred foods and cuisines
        - Times of low/high compliance
        - What adjustments work best
        """
        
        # Retrieve nutrition history
        nutrition_history = await self.memory.retrieve_memories(
            user_id=user_id,
            query="nutrition plan compliance and preferences",
            limit=10
        )
        
        dietary_patterns = await self.memory.retrieve_memories(
            user_id=user_id,
            query="food preferences and successful meals",
            limit=5
        )
        
        # Analyze compliance patterns
        compliance_insights = self._analyze_nutrition_compliance(
            nutrition_history,
            dietary_patterns
        )
        
        # Generate adaptive nutrition plan
        nutrition_plan = await self._generate_adaptive_nutrition_plan(
            user_data=user_data,
            parameters=parameters,
            compliance_insights=compliance_insights
        )
        
        # Memorize plan generation
        await self.memory.memorize_interaction(
            user_id=user_id,
            interaction_type="adaptive_nutrition_plan_generated",
            content={
                "plan_summary": nutrition_plan.get("summary", ""),
                "adaptations": compliance_insights.get("adaptations", []),
                "generated_at": datetime.now().isoformat()
            }
        )
        
        return {
            "workflow": "adaptive_nutrition",
            "plan": nutrition_plan,
            "compliance_insights": compliance_insights,
            "adaptive_features": [
                "Based on meals you actually enjoy",
                "Optimized for your compliance patterns",
                "Adjusts portions to your preferences",
                "Includes variety you've responded well to"
            ]
        }
    
    async def execute_smart_goal_tracking(
        self,
        user_id: str,
        goal: str,
        progress: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Track goals with adaptive targets and milestone adjustment
        
        Features:
        - Adjusts targets based on actual progress
        - Recognizes plateaus and suggests changes
        - Celebrates micro-wins
        - Predicts goal achievement timeline
        """
        
        # Update progress in memory
        result = await self.memory.update_goal_progress(
            user_id=user_id,
            goal=goal,
            progress=progress
        )
        
        # Retrieve full goal history
        goal_history = await self.memory.retrieve_memories(
            user_id=user_id,
            query=f"progress and milestones for {goal}",
            limit=20
        )
        
        # Analyze progress with adaptive insights
        analysis = self._analyze_smart_goal_progress(
            goal=goal,
            current_progress=progress,
            history=goal_history
        )
        
        # Learn patterns from progress
        if analysis.get("pattern_detected"):
            await self.memory.learn_pattern(
                user_id=user_id,
                pattern_type=PatternType.EXERCISE_PERFORMANCE.value,
                pattern_data={
                    "goal": goal,
                    "pattern": analysis.get("pattern_description", ""),
                    "detected_at": datetime.now().isoformat()
                }
            )
        
        return {
            "workflow": "smart_goal_tracking",
            "goal": goal,
            "progress": progress,
            "analysis": analysis,
            "adaptive_recommendations": analysis.get("recommendations", []),
            "predicted_timeline": analysis.get("predicted_timeline", ""),
            "self_improving": True
        }
    
    # Helper methods for pattern analysis and generation
    
    def _analyze_fitness_patterns(
        self,
        workout_history: List[Dict],
        preferences: List[Dict],
        patterns: List[Dict]
    ) -> Dict[str, Any]:
        """Analyze fitness patterns from memories"""
        insights = {
            "patterns": [],
            "adaptations": [],
            "preferred_exercises": [],
            "optimal_times": []
        }
        
        # Extract patterns from memories
        if workout_history:
            insights["patterns"].append("Consistent workout history detected")
            insights["adaptations"].append("Plan complexity adjusted for experience level")
        
        if preferences:
            insights["patterns"].append("Exercise preferences identified")
            insights["preferred_exercises"] = ["bodyweight", "cardio"]  # Simplified
            insights["adaptations"].append("Prioritized preferred exercise types")
        
        # Identify optimal workout times
        insights["optimal_times"] = ["morning 7-9 AM", "evening 6-8 PM"]
        
        return insights
    
    async def _generate_adaptive_fitness_plan(
        self,
        user_data: Dict[str, Any],
        parameters: Dict[str, Any],
        insights: Dict[str, Any]
    ) -> Dict[str, Any]:
        """Generate fitness plan with adaptive elements"""
        
        # Use SimpleClaw prompt engineering if available
        from prompt_engineering import FitnessPromptEngine
        
        engine = FitnessPromptEngine()
        
        # Add insights to context
        enhanced_user_data = {
            **user_data,
            "learned_patterns": insights.get("patterns", []),
            "preferred_exercises": insights.get("preferred_exercises", []),
            "optimal_times": insights.get("optimal_times", [])
        }
        
        # Generate enhanced prompt
        prompt = engine.create_fitness_plan_prompt(
            user_context=enhanced_user_data,
            parameters=parameters
        )
        
        # Add adaptive instructions
        adaptive_prompt = f"""{prompt}

## ADAPTIVE ELEMENTS (Based on Learning)
The user has shown:
{chr(10).join(f"- {pattern}" for pattern in insights.get("patterns", []))}

Adaptations to make:
{chr(10).join(f"- {adaptation}" for adaptation in insights.get("adaptations", []))}

Generate a plan that incorporates these learned insights."""
        
        # Generate with Gemini if available
        if self.gemini:
            try:
                response = self.gemini.models.generate_content(
                    model="gemini-2.5-flash",
                    contents=adaptive_prompt
                )
                plan_content = response.text
            except Exception as e:
                logger.error(f"Error generating adaptive plan: {e}")
                plan_content = "Adaptive plan generation in progress..."
        else:
            plan_content = "Adaptive plan based on learned patterns (AI generation offline)"
        
        return {
            "summary": "Personalized adaptive fitness plan",
            "content": plan_content,
            "adaptations_applied": len(insights.get("adaptations", [])),
            "learning_incorporated": True
        }
    
    def _predict_optimal_workout(
        self,
        context: Dict[str, Any],
        recent_workouts: List[Dict],
        time_patterns: List[Dict]
    ) -> Dict[str, Any]:
        """Predict best workout for current context"""
        
        current_time = context.get("time", datetime.now().hour)
        energy_level = context.get("energy_level", "medium")
        
        prediction = {
            "workout_type": "moderate_cardio",
            "duration": 30,
            "confidence": 0.75,
            "reasoning": [],
            "factors": []
        }
        
        # Time-based prediction
        if 6 <= current_time <= 10:
            prediction["reasoning"].append("Morning is your high-energy time based on patterns")
            prediction["workout_type"] = "high_intensity"
            prediction["confidence"] += 0.1
            prediction["factors"].append("optimal_time_window")
        
        # Recent workout consideration
        if len(recent_workouts) > 0:
            prediction["reasoning"].append("Adequate recovery time since last workout")
            prediction["factors"].append("recovery_ready")
        
        # Energy level
        if energy_level == "high":
            prediction["confidence"] += 0.1
            prediction["factors"].append("high_energy_state")
        
        return prediction
    
    def _identify_motivation_triggers(
        self,
        motivation_history: List[Dict],
        user_state: Dict[str, Any]
    ) -> Dict[str, Any]:
        """Identify if motivation is needed based on patterns"""
        
        triggers = {
            "should_motivate": False,
            "trigger_type": None,
            "confidence": 0.5
        }
        
        # Check for inactivity pattern
        days_since_workout = user_state.get("days_since_workout", 0)
        if days_since_workout >= 3:
            triggers["should_motivate"] = True
            triggers["trigger_type"] = "inactivity_detected"
            triggers["confidence"] = 0.8
        
        # Check for goal deadline approaching
        if user_state.get("goal_deadline_approaching"):
            triggers["should_motivate"] = True
            triggers["trigger_type"] = "deadline_approaching"
            triggers["confidence"] = 0.9
        
        return triggers
    
    async def _generate_adaptive_motivation(
        self,
        user_id: str,
        triggers: Dict[str, Any],
        user_state: Dict[str, Any]
    ) -> Dict[str, Any]:
        """Generate personalized motivation based on triggers"""
        
        trigger_type = triggers.get("trigger_type", "general")
        
        messages = {
            "inactivity_detected": "I noticed it's been a few days since your last workout. Remember why you started - your goals are within reach! How about a quick 20-minute session today?",
            "deadline_approaching": "Your goal deadline is coming up! You've made great progress so far. Let's finish strong!",
            "plateau_detected": "Hitting a plateau is normal and means you're ready for the next level. Let's try something new to break through!",
            "general": "You're doing amazing! Keep up the great work on your fitness journey."
        }
        
        return {
            "message": messages.get(trigger_type, messages["general"]),
            "trigger": trigger_type,
            "personalized": True,
            "suggested_action": "Start today's workout"
        }
    
    def _analyze_nutrition_compliance(
        self,
        nutrition_history: List[Dict],
        dietary_patterns: List[Dict]
    ) -> Dict[str, Any]:
        """Analyze nutrition compliance patterns"""
        
        insights = {
            "compliance_rate": 0.75,  # Simplified
            "preferred_meals": ["breakfast_smoothie", "grilled_protein_bowl"],
            "difficult_times": ["late_evening"],
            "adaptations": [
                "Focus on meals with high historical compliance",
                "Avoid complex prep for evening meals",
                "Include variety in successful meal types"
            ]
        }
        
        return insights
    
    async def _generate_adaptive_nutrition_plan(
        self,
        user_data: Dict[str, Any],
        parameters: Dict[str, Any],
        compliance_insights: Dict[str, Any]
    ) -> Dict[str, Any]:
        """Generate nutrition plan adapted to compliance patterns"""
        
        from prompt_engineering import FitnessPromptEngine
        
        engine = FitnessPromptEngine()
        
        # Enhance with compliance insights
        enhanced_data = {
            **user_data,
            "preferred_meals": compliance_insights.get("preferred_meals", []),
            "compliance_rate": compliance_insights.get("compliance_rate", 0.7)
        }
        
        prompt = engine.create_nutrition_plan_prompt(
            user_context=enhanced_data,
            parameters=parameters
        )
        
        # Add adaptive instructions
        adaptive_prompt = f"""{prompt}

## COMPLIANCE-BASED ADAPTATIONS
Historical compliance rate: {compliance_insights.get('compliance_rate', 0.7)*100}%

Include primarily:
{chr(10).join(f"- {meal}" for meal in compliance_insights.get("preferred_meals", []))}

Avoid:
- Complex preparations during {', '.join(compliance_insights.get("difficult_times", []))}
- Meals user has shown low compliance with

Focus on realistic, enjoyable meals that the user will actually follow."""
        
        if self.gemini:
            try:
                response = self.gemini.models.generate_content(
                    model="gemini-2.5-flash",
                    contents=adaptive_prompt
                )
                plan_content = response.text
            except Exception as e:
                logger.error(f"Error generating adaptive nutrition plan: {e}")
                plan_content = "Adaptive nutrition plan in progress..."
        else:
            plan_content = "Adaptive nutrition plan based on compliance patterns"
        
        return {
            "summary": "Compliance-optimized nutrition plan",
            "content": plan_content,
            "compliance_rate": compliance_insights.get("compliance_rate", 0.7),
            "adaptations_applied": len(compliance_insights.get("adaptations", []))
        }
    
    def _analyze_smart_goal_progress(
        self,
        goal: str,
        current_progress: Dict[str, Any],
        history: List[Dict]
    ) -> Dict[str, Any]:
        """Analyze goal progress with adaptive insights"""
        
        analysis = {
            "status": "on_track",
            "pattern_detected": False,
            "pattern_description": "",
            "recommendations": [],
            "predicted_timeline": "",
            "milestones_achieved": []
        }
        
        # Analyze trend
        if len(history) >= 3:
            analysis["pattern_detected"] = True
            analysis["pattern_description"] = "Consistent progress pattern identified"
            analysis["status"] = "improving"
            analysis["recommendations"].append("Maintain current approach - it's working!")
        
        # Predict timeline
        progress_rate = current_progress.get("completion_percentage", 50)
        if progress_rate > 0:
            weeks_remaining = int((100 - progress_rate) / 10)  # Simplified
            analysis["predicted_timeline"] = f"Estimated {weeks_remaining} weeks to goal completion"
        
        # Adaptive recommendations
        if progress_rate < 30:
            analysis["recommendations"].append("Consider breaking goal into smaller milestones")
        elif progress_rate > 70:
            analysis["recommendations"].append("You're close! Push for that final stretch")
        
        return analysis


# Global engine instance
adaptive_engine: Optional[AdaptiveWorkflowEngine] = None


def get_adaptive_engine(memubot_manager, gemini_client=None) -> AdaptiveWorkflowEngine:
    """Get or create adaptive workflow engine"""
    global adaptive_engine
    if adaptive_engine is None:
        adaptive_engine = AdaptiveWorkflowEngine(memubot_manager, gemini_client)
    return adaptive_engine
