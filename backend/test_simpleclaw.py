"""
Test SimpleClaw Integration
Quick smoke tests to verify the SimpleClaw integration works
"""
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from simpleclaw_integration import SimpleClawOrchestrator, WorkflowType
from prompt_engineering import FitnessPromptEngine
import asyncio


async def test_prompt_engine():
    """Test prompt engineering module"""
    print("\n=== Testing Prompt Engineering ===")
    
    engine = FitnessPromptEngine()
    
    # Test fitness plan prompt
    prompt = engine.create_fitness_plan_prompt(
        user_context={
            "age": 30,
            "weight": 75,
            "height": 180,
            "body_type": "Mesomorph",
            "goals": ["Weight Loss"]
        },
        parameters={
            "duration_days": 30
        }
    )
    
    assert "fitness plan" in prompt.lower()
    assert "30" in prompt
    assert "Mesomorph" in prompt
    print("✓ Fitness plan prompt generated successfully")
    
    # Test chat prompt
    chat_prompt = engine.create_chat_prompt(
        user_context={"age": 25, "goals": ["Muscle Gain"]},
        message="What exercises build muscle?"
    )
    
    assert "fitness coach" in chat_prompt.lower()
    assert "What exercises build muscle?" in chat_prompt
    print("✓ Chat prompt generated successfully")
    
    # Test nutrition prompt
    nutrition_prompt = engine.create_nutrition_plan_prompt(
        user_context={
            "age": 35,
            "weight": 80,
            "height": 175,
            "goals": ["Weight Loss"],
            "city": "New York"
        },
        parameters={
            "duration_days": 7
        }
    )
    
    assert "nutrition" in nutrition_prompt.lower()
    assert "New York" in nutrition_prompt
    print("✓ Nutrition plan prompt generated successfully")
    
    print("✅ All prompt engineering tests passed!")


async def test_simpleclaw_orchestrator():
    """Test SimpleClaw orchestrator without Gemini client"""
    print("\n=== Testing SimpleClaw Orchestrator ===")
    
    orchestrator = SimpleClawOrchestrator(gemini_client=None)
    
    # Test workflow initialization
    result = await orchestrator.start_workflow(
        user_id="test_user_123",
        workflow_type="fitness_plan",
        user_data={
            "age": 28,
            "weight": 70,
            "height": 175,
            "body_type": "Ectomorph",
            "goals": ["Muscle Gain"]
        },
        parameters={
            "duration_days": 30
        }
    )
    
    assert "session_id" in result
    assert "workflow_result" in result
    assert result["status"] == "success"
    print(f"✓ Workflow started: {result['session_id']}")
    
    # Test session retrieval
    session_info = orchestrator.get_session_info(result["session_id"])
    assert session_info is not None
    assert session_info["user_id"] == "test_user_123"
    print("✓ Session info retrieved successfully")
    
    # Test memory
    memory = orchestrator.get_user_memory("test_user_123")
    assert len(memory) > 0
    print(f"✓ User memory retrieved: {len(memory)} interactions")
    
    # Test multiple workflows for same user
    result2 = await orchestrator.start_workflow(
        user_id="test_user_123",
        workflow_type="chat_assistant",
        user_data={"age": 28},
        parameters={"message": "How can I gain muscle?"}
    )
    
    # Check memory persistence
    memory2 = orchestrator.get_user_memory("test_user_123")
    assert len(memory2) == 2
    print("✓ Memory persisted across workflows")
    
    print("✅ All SimpleClaw orchestrator tests passed!")


async def test_workflow_types():
    """Test all workflow types"""
    print("\n=== Testing All Workflow Types ===")
    
    orchestrator = SimpleClawOrchestrator(gemini_client=None)
    
    workflows = [
        ("fitness_plan", {"duration_days": 30}),
        ("nutrition_plan", {"duration_days": 7, "city": "Boston"}),
        ("chat_assistant", {"message": "Hello"}),
        ("goal_tracking", {"goal": "Lose 5kg", "days_elapsed": 15}),
        ("motivation", {"situation": "feeling discouraged"})
    ]
    
    for workflow_type, params in workflows:
        result = await orchestrator.start_workflow(
            user_id=f"user_{workflow_type}",
            workflow_type=workflow_type,
            user_data={"age": 30, "weight": 75},
            parameters=params
        )
        
        assert result["status"] == "success"
        assert "session_id" in result
        print(f"✓ {workflow_type} workflow executed")
    
    print("✅ All workflow types tested successfully!")


async def main():
    """Run all tests"""
    print("=" * 60)
    print("SimpleClaw Integration Tests")
    print("=" * 60)
    
    try:
        await test_prompt_engine()
        await test_simpleclaw_orchestrator()
        await test_workflow_types()
        
        print("\n" + "=" * 60)
        print("🎉 ALL TESTS PASSED!")
        print("=" * 60)
        
    except Exception as e:
        print(f"\n❌ Test failed: {str(e)}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    asyncio.run(main())
