"""
Self-Improving AI Orchestrator
Combines MemuBot memory with SimpleClaw workflows for truly adaptive AI

This orchestrator:
- Learns from every interaction
- Adapts strategies based on outcomes
- Improves recommendations over time
- Makes proactive suggestions
"""
import logging
from typing import Dict, Any, Optional, List
from datetime import datetime

logger = logging.getLogger(__name__)


class SelfImprovingOrchestrator:
    """
    Orchestrator that combines:
    - MemuBot: Long-term memory and learning
    - SimpleClaw: Lightweight workflow execution
    - Adaptive Workflows: Pattern recognition and adaptation
    - Gemini AI: Intelligent generation
    """
    
    def __init__(self, memubot_manager, adaptive_engine, simpleclaw_orchestrator=None):
        """
        Initialize self-improving orchestrator
        
        Args:
            memubot_manager: MemuBot manager for memory
            adaptive_engine: Adaptive workflow engine
            simpleclaw_orchestrator: Optional SimpleClaw orchestrator
        """
        self.memory = memubot_manager
        self.adaptive = adaptive_engine
        self.simpleclaw = simpleclaw_orchestrator
        self.improvement_cycles = 0
    
    async def execute_with_learning(
        self,
        user_id: str,
        workflow_type: str,
        user_data: Dict[str, Any],
        parameters: Optional[Dict[str, Any]] = None
    ) -> Dict[str, Any]:
        """
        Execute workflow with continuous learning
        
        Process:
        1. Retrieve relevant memories
        2. Apply learned patterns
        3. Execute workflow
        4. Memorize results
        5. Update patterns
        6. Return enhanced results
        """
        
        start_time = datetime.now()
        
        # Step 1: Retrieve context from memory
        context = await self._retrieve_execution_context(user_id, workflow_type)
        
        # Step 2: Execute adaptive workflow
        if workflow_type == "learning_fitness_plan":
            result = await self.adaptive.execute_learning_fitness_plan(
                user_id=user_id,
                user_data=user_data,
                parameters=parameters or {}
            )
        elif workflow_type == "predictive_workout":
            result = await self.adaptive.execute_predictive_workout(
                user_id=user_id,
                context={**user_data, **(parameters or {})}
            )
        elif workflow_type == "proactive_motivation":
            result = await self.adaptive.execute_proactive_motivation(
                user_id=user_id,
                user_state={**user_data, **(parameters or {})}
            )
        elif workflow_type == "adaptive_nutrition":
            result = await self.adaptive.execute_adaptive_nutrition(
                user_id=user_id,
                user_data=user_data,
                parameters=parameters or {}
            )
        elif workflow_type == "smart_goal_tracking":
            goal = parameters.get("goal", "fitness goal")
            progress = parameters.get("progress", {})
            result = await self.adaptive.execute_smart_goal_tracking(
                user_id=user_id,
                goal=goal,
                progress=progress
            )
        else:
            # Fall back to SimpleClaw if available
            if self.simpleclaw:
                result = await self.simpleclaw.start_workflow(
                    user_id=user_id,
                    workflow_type=workflow_type,
                    user_data=user_data,
                    parameters=parameters
                )
            else:
                result = {
                    "error": f"Unknown workflow type: {workflow_type}"
                }
        
        execution_time = (datetime.now() - start_time).total_seconds()
        
        # Step 3: Memorize execution for learning
        await self._memorize_execution(
            user_id=user_id,
            workflow_type=workflow_type,
            result=result,
            execution_time=execution_time
        )
        
        # Step 4: Update improvement cycle
        self.improvement_cycles += 1
        
        # Step 5: Enhance result with learning metadata
        enhanced_result = {
            **result,
            "self_improving": True,
            "learning_metadata": {
                "context_memories_used": len(context.get("memories", [])),
                "improvement_cycle": self.improvement_cycles,
                "execution_time_seconds": execution_time,
                "memory_enabled": self.memory.enabled,
                "patterns_learned": context.get("patterns_count", 0)
            }
        }
        
        return enhanced_result
    
    async def get_proactive_insights(
        self,
        user_id: str,
        current_context: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Get proactive insights and suggestions
        
        This method demonstrates true AI intelligence:
        - Anticipates user needs
        - Suggests actions before being asked
        - Adapts to user patterns
        """
        
        # Get proactive suggestions from memory
        suggestions = await self.memory.get_proactive_suggestions(
            user_id=user_id,
            context=current_context
        )
        
        # Check if motivation is needed
        motivation_result = await self.adaptive.execute_proactive_motivation(
            user_id=user_id,
            user_state=current_context
        )
        
        # Get predictive workout suggestion
        workout_prediction = await self.adaptive.execute_predictive_workout(
            user_id=user_id,
            context=current_context
        )
        
        insights = {
            "timestamp": datetime.now().isoformat(),
            "proactive_suggestions": suggestions,
            "motivation_needed": motivation_result.get("should_send", False),
            "motivation_message": motivation_result.get("motivation", {}).get("message"),
            "workout_prediction": workout_prediction.get("prediction"),
            "self_improved": True,
            "confidence_score": self._calculate_confidence(suggestions, motivation_result, workout_prediction)
        }
        
        return insights
    
    async def provide_feedback(
        self,
        user_id: str,
        workflow_id: str,
        feedback: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Accept feedback to improve future recommendations
        
        This creates a feedback loop for continuous improvement
        """
        
        # Memorize feedback
        await self.memory.memorize_interaction(
            user_id=user_id,
            interaction_type="feedback_received",
            content={
                "workflow_id": workflow_id,
                "feedback": feedback,
                "timestamp": datetime.now().isoformat()
            }
        )
        
        # Analyze feedback for patterns
        if feedback.get("helpful", False):
            await self.memory.learn_pattern(
                user_id=user_id,
                pattern_type="successful_recommendation",
                pattern_data={
                    "workflow_id": workflow_id,
                    "what_worked": feedback.get("what_worked", "")
                }
            )
        else:
            await self.memory.learn_pattern(
                user_id=user_id,
                pattern_type="unsuccessful_recommendation",
                pattern_data={
                    "workflow_id": workflow_id,
                    "what_to_avoid": feedback.get("what_to_avoid", "")
                }
            )
        
        return {
            "feedback_processed": True,
            "learning_updated": True,
            "message": "Thank you! I'll use this to improve future recommendations."
        }
    
    async def get_learning_stats(self, user_id: str) -> Dict[str, Any]:
        """
        Get statistics on what the AI has learned about the user
        
        Transparency in AI learning
        """
        
        # Retrieve all memory categories
        memories = await self.memory.retrieve_memories(
            user_id=user_id,
            query="all interactions and patterns",
            limit=50
        )
        
        patterns = await self.memory.retrieve_memories(
            user_id=user_id,
            query="learned patterns and preferences",
            limit=20
        )
        
        stats = {
            "user_id": user_id,
            "total_interactions": len(memories),
            "patterns_learned": len(patterns),
            "improvement_cycles": self.improvement_cycles,
            "memory_enabled": self.memory.enabled,
            "learning_categories": [
                "Workout Preferences",
                "Nutrition Compliance",
                "Motivation Triggers",
                "Performance Patterns",
                "Goal Progress"
            ],
            "ai_capabilities": [
                "Learns from every interaction",
                "Adapts plans to your patterns",
                "Predicts optimal workout times",
                "Provides proactive motivation",
                "Improves recommendations over time"
            ],
            "recent_learnings": [
                str(pattern.get("content", ""))[:100] + "..."
                for pattern in patterns[:3]
            ]
        }
        
        return stats
    
    # Helper methods
    
    async def _retrieve_execution_context(
        self,
        user_id: str,
        workflow_type: str
    ) -> Dict[str, Any]:
        """Retrieve relevant context from memory for workflow execution"""
        
        memories = await self.memory.retrieve_memories(
            user_id=user_id,
            query=f"relevant context for {workflow_type}",
            limit=10
        )
        
        patterns = await self.memory.retrieve_memories(
            user_id=user_id,
            query="learned patterns and preferences",
            limit=5
        )
        
        return {
            "memories": memories,
            "patterns_count": len(patterns),
            "context_available": len(memories) > 0
        }
    
    async def _memorize_execution(
        self,
        user_id: str,
        workflow_type: str,
        result: Dict[str, Any],
        execution_time: float
    ):
        """Memorize workflow execution for learning"""
        
        await self.memory.memorize_interaction(
            user_id=user_id,
            interaction_type=f"workflow_executed_{workflow_type}",
            content={
                "workflow_type": workflow_type,
                "success": not result.get("error"),
                "execution_time": execution_time,
                "timestamp": datetime.now().isoformat()
            }
        )
    
    def _calculate_confidence(
        self,
        suggestions: List[Dict],
        motivation: Dict[str, Any],
        workout: Dict[str, Any]
    ) -> float:
        """Calculate overall confidence score for proactive insights"""
        
        scores = []
        
        if suggestions:
            scores.extend([s.get("confidence", 0.5) for s in suggestions])
        
        if motivation.get("should_send"):
            scores.append(motivation.get("confidence", 0.5))
        
        if workout.get("prediction"):
            scores.append(workout.get("confidence", 0.5))
        
        return sum(scores) / len(scores) if scores else 0.5


# Global orchestrator instance
self_improving_orchestrator: Optional[SelfImprovingOrchestrator] = None


def get_self_improving_orchestrator(
    memubot_manager,
    adaptive_engine,
    simpleclaw_orchestrator=None
) -> SelfImprovingOrchestrator:
    """Get or create self-improving orchestrator"""
    global self_improving_orchestrator
    if self_improving_orchestrator is None:
        self_improving_orchestrator = SelfImprovingOrchestrator(
            memubot_manager=memubot_manager,
            adaptive_engine=adaptive_engine,
            simpleclaw_orchestrator=simpleclaw_orchestrator
        )
    return self_improving_orchestrator
