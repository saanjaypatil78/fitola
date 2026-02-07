"""
Test MemuBot Integration
Tests for adaptive self-improving AI with MemuBot
"""
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from memubot_integration import MemuBotManager, MemoryCategory
from adaptive_workflows import AdaptiveWorkflowEngine
from self_improving_orchestrator import SelfImprovingOrchestrator
import asyncio


async def test_memubot_manager():
    """Test MemuBot manager functionality"""
    print("\n=== Testing MemuBot Manager ===")
    
    # Initialize without API key (mock mode)
    manager = MemuBotManager()
    assert manager.enabled == False, "Should run in mock mode without API key"
    print("✓ MemuBot manager initialized in mock mode")
    
    # Test memorization
    result = await manager.memorize_interaction(
        user_id="test_user_001",
        interaction_type="workout_completed",
        content={
            "workout": "30min cardio",
            "calories": 250,
            "intensity": "moderate"
        },
        category=MemoryCategory.WORKOUT_HISTORY
    )
    
    assert "task_id" in result
    assert result["status"] == "memorized_mock"
    print(f"✓ Interaction memorized: {result['task_id']}")
    
    # Test retrieval
    memories = await manager.retrieve_memories(
        user_id="test_user_001",
        query="workout history",
        limit=5
    )
    
    assert len(memories) == 1
    assert memories[0]["interaction_type"] == "workout_completed"
    print(f"✓ Retrieved {len(memories)} memories")
    
    # Test pattern learning
    pattern_result = await manager.learn_pattern(
        user_id="test_user_001",
        pattern_type="workout_preference",
        pattern_data={"preferred_time": "morning", "preferred_type": "cardio"}
    )
    
    assert "task_id" in pattern_result
    print("✓ Pattern learned successfully")
    
    # Test proactive suggestions
    suggestions = await manager.get_proactive_suggestions(
        user_id="test_user_001",
        context={"time": 7, "day": "Monday"}
    )
    
    assert isinstance(suggestions, list)
    print(f"✓ Generated {len(suggestions)} proactive suggestions")
    
    print("✅ All MemuBot manager tests passed!")


async def test_adaptive_workflows():
    """Test adaptive workflow engine"""
    print("\n=== Testing Adaptive Workflows ===")
    
    manager = MemuBotManager()
    engine = AdaptiveWorkflowEngine(manager, gemini_client=None)
    
    # Test learning fitness plan
    result = await engine.execute_learning_fitness_plan(
        user_id="test_user_002",
        user_data={
            "age": 30,
            "weight": 75,
            "height": 180,
            "goals": ["Muscle Gain"]
        },
        parameters={"duration_days": 30}
    )
    
    assert result["workflow"] == "learning_fitness_plan"
    assert "plan" in result
    assert "insights_used" in result
    assert "adaptive_features" in result
    print("✓ Learning fitness plan generated")
    print(f"  Adaptive features: {len(result['adaptive_features'])}")
    
    # Test predictive workout
    prediction = await engine.execute_predictive_workout(
        user_id="test_user_002",
        context={"time": 8, "energy_level": "high"}
    )
    
    assert prediction["workflow"] == "predictive_workout"
    assert "prediction" in prediction
    assert "confidence" in prediction
    print(f"✓ Workout predicted with {prediction['confidence']*100:.0f}% confidence")
    
    # Test proactive motivation
    motivation = await engine.execute_proactive_motivation(
        user_id="test_user_002",
        user_state={"days_since_workout": 4}
    )
    
    assert motivation["workflow"] == "proactive_motivation"
    print(f"✓ Motivation check: {motivation['should_send']}")
    
    # Test adaptive nutrition
    nutrition = await engine.execute_adaptive_nutrition(
        user_id="test_user_002",
        user_data={
            "age": 30,
            "weight": 75,
            "height": 180,
            "city": "New York"
        },
        parameters={"duration_days": 7}
    )
    
    assert nutrition["workflow"] == "adaptive_nutrition"
    assert "plan" in nutrition
    assert "compliance_insights" in nutrition
    print("✓ Adaptive nutrition plan generated")
    
    # Test smart goal tracking
    goal_result = await engine.execute_smart_goal_tracking(
        user_id="test_user_002",
        goal="Lose 5kg",
        progress={"current_loss": "2kg", "completion_percentage": 40}
    )
    
    assert goal_result["workflow"] == "smart_goal_tracking"
    assert "analysis" in goal_result
    assert "predicted_timeline" in goal_result
    print(f"✓ Goal tracked: {goal_result['analysis']['status']}")
    
    print("✅ All adaptive workflow tests passed!")


async def test_self_improving_orchestrator():
    """Test self-improving orchestrator"""
    print("\n=== Testing Self-Improving Orchestrator ===")
    
    manager = MemuBotManager()
    engine = AdaptiveWorkflowEngine(manager, gemini_client=None)
    orchestrator = SelfImprovingOrchestrator(manager, engine)
    
    # Test workflow execution with learning
    result = await orchestrator.execute_with_learning(
        user_id="test_user_003",
        workflow_type="learning_fitness_plan",
        user_data={"age": 28, "weight": 70, "height": 175},
        parameters={"duration_days": 30}
    )
    
    assert "self_improving" in result
    assert result["self_improving"] == True
    assert "learning_metadata" in result
    print("✓ Workflow executed with learning")
    print(f"  Improvement cycle: {result['learning_metadata']['improvement_cycle']}")
    
    # Test proactive insights
    insights = await orchestrator.get_proactive_insights(
        user_id="test_user_003",
        current_context={"time": 7, "energy_level": "high"}
    )
    
    assert "proactive_suggestions" in insights
    assert "self_improved" in insights
    assert "confidence_score" in insights
    print(f"✓ Proactive insights generated (confidence: {insights['confidence_score']:.2f})")
    
    # Test feedback loop
    feedback_result = await orchestrator.provide_feedback(
        user_id="test_user_003",
        workflow_id="test_workflow_001",
        feedback={
            "helpful": True,
            "what_worked": "Personalized timing suggestions"
        }
    )
    
    assert feedback_result["feedback_processed"] == True
    assert feedback_result["learning_updated"] == True
    print("✓ Feedback processed and learning updated")
    
    # Test learning stats
    stats = await orchestrator.get_learning_stats("test_user_003")
    
    assert "total_interactions" in stats
    assert "patterns_learned" in stats
    assert "ai_capabilities" in stats
    print(f"✓ Learning stats retrieved:")
    print(f"  Total interactions: {stats['total_interactions']}")
    print(f"  Patterns learned: {stats['patterns_learned']}")
    print(f"  AI capabilities: {len(stats['ai_capabilities'])}")
    
    print("✅ All self-improving orchestrator tests passed!")


async def test_memory_categories():
    """Test memory category organization"""
    print("\n=== Testing Memory Categories ===")
    
    manager = MemuBotManager()
    
    categories = [
        (MemoryCategory.USER_PROFILE, "Basic profile info"),
        (MemoryCategory.FITNESS_GOALS, "Long-term fitness goals"),
        (MemoryCategory.WORKOUT_HISTORY, "Past workout completions"),
        (MemoryCategory.NUTRITION_PREFS, "Dietary preferences"),
        (MemoryCategory.PROGRESS_METRICS, "Weight and measurements"),
        (MemoryCategory.PREFERENCES, "User likes/dislikes"),
        (MemoryCategory.PATTERNS, "Behavioral patterns"),
        (MemoryCategory.MOTIVATIONS, "What motivates user"),
        (MemoryCategory.CHALLENGES, "Obstacles faced")
    ]
    
    for category, description in categories:
        result = await manager.memorize_interaction(
            user_id="test_user_categories",
            interaction_type="category_test",
            content={"description": description},
            category=category
        )
        assert result["category"] == category.value
    
    print(f"✓ All {len(categories)} memory categories tested")
    print("✅ Memory category tests passed!")


async def test_continuous_learning():
    """Test continuous learning over multiple interactions"""
    print("\n=== Testing Continuous Learning ===")
    
    manager = MemuBotManager()
    engine = AdaptiveWorkflowEngine(manager, gemini_client=None)
    orchestrator = SelfImprovingOrchestrator(manager, engine)
    
    user_id = "test_user_learning"
    
    # Simulate multiple workout completions
    for i in range(5):
        await manager.memorize_interaction(
            user_id=user_id,
            interaction_type="workout_completed",
            content={
                "workout_number": i + 1,
                "type": "cardio" if i % 2 == 0 else "strength",
                "duration": 30 + (i * 5),
                "satisfaction": 4 + (i % 2)
            },
            category=MemoryCategory.WORKOUT_HISTORY
        )
    
    print(f"✓ Simulated 5 workout interactions")
    
    # Retrieve and verify learning
    memories = await manager.retrieve_memories(
        user_id=user_id,
        query="workout history and patterns",
        limit=10
    )
    
    assert len(memories) == 5
    print(f"✓ All {len(memories)} interactions stored in memory")
    
    # Get adaptive plan based on history
    plan_result = await orchestrator.execute_with_learning(
        user_id=user_id,
        workflow_type="learning_fitness_plan",
        user_data={"age": 25, "weight": 70, "height": 175},
        parameters={"duration_days": 30}
    )
    
    learning_meta = plan_result["learning_metadata"]
    assert learning_meta["context_memories_used"] > 0
    print(f"✓ Plan generated using {learning_meta['context_memories_used']} memories")
    
    # Verify improvement cycles
    assert orchestrator.improvement_cycles > 0
    print(f"✓ Improvement cycles: {orchestrator.improvement_cycles}")
    
    print("✅ Continuous learning test passed!")


async def main():
    """Run all tests"""
    print("=" * 60)
    print("MemuBot Integration Tests")
    print("Adaptive Self-Improving AI for Fitola")
    print("=" * 60)
    
    try:
        await test_memubot_manager()
        await test_adaptive_workflows()
        await test_self_improving_orchestrator()
        await test_memory_categories()
        await test_continuous_learning()
        
        print("\n" + "=" * 60)
        print("🎉 ALL TESTS PASSED!")
        print("=" * 60)
        print("\nMemuBot Integration Summary:")
        print("✅ 24/7 Proactive Memory")
        print("✅ Continuous Learning")
        print("✅ Pattern Recognition")
        print("✅ Adaptive Workflows")
        print("✅ Self-Improvement")
        print("✅ Feedback Loops")
        print("\nReady for production use!")
        
    except Exception as e:
        print(f"\n❌ Test failed: {str(e)}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    asyncio.run(main())
