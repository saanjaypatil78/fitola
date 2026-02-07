"""
SimpleClaw Integration for Fitola
A lightweight, simplified AI workflow orchestration avoiding complex OpenClaw setup

SimpleClaw provides:
- One-click workflow execution
- Zero-configuration agent deployment
- Simplified prompt engineering
- Easy integration with existing AI models (Gemini)
"""
import logging
from typing import Dict, Any, Optional, List
from enum import Enum
from pydantic import BaseModel
from datetime import datetime

logger = logging.getLogger(__name__)


class WorkflowType(str, Enum):
    """Simple workflow types for fitness coaching"""
    FITNESS_PLAN = "fitness_plan"
    NUTRITION_PLAN = "nutrition_plan"
    CHAT_ASSISTANT = "chat_assistant"
    GOAL_TRACKING = "goal_tracking"
    MOTIVATION = "motivation"


class SimpleCLawAgent:
    """
    Simplified AI Agent inspired by SimpleClaw philosophy:
    - Easy to use, no complex setup
    - Fast deployment (<1 minute)
    - Focused on fitness domain
    - Prompt-engineered for better results
    """
    
    def __init__(self, gemini_client=None):
        self.client = gemini_client
        self.context_memory: Dict[str, List[Dict]] = {}
        
    async def execute_workflow(
        self,
        workflow_type: WorkflowType,
        user_context: Dict[str, Any],
        parameters: Optional[Dict[str, Any]] = None
    ) -> Dict[str, Any]:
        """
        Execute a simplified workflow based on type
        No complex setup required - just call and go!
        """
        workflow_handlers = {
            WorkflowType.FITNESS_PLAN: self._generate_fitness_plan,
            WorkflowType.NUTRITION_PLAN: self._generate_nutrition_plan,
            WorkflowType.CHAT_ASSISTANT: self._handle_chat,
            WorkflowType.GOAL_TRACKING: self._track_goal,
            WorkflowType.MOTIVATION: self._provide_motivation,
        }
        
        handler = workflow_handlers.get(workflow_type)
        if not handler:
            raise ValueError(f"Unknown workflow type: {workflow_type}")
        
        # Store context for memory persistence
        user_id = user_context.get("user_id", "unknown")
        self._store_context(user_id, workflow_type, user_context, parameters)
        
        return await handler(user_context, parameters or {})
    
    def _store_context(
        self,
        user_id: str,
        workflow_type: WorkflowType,
        context: Dict[str, Any],
        parameters: Optional[Dict[str, Any]]
    ):
        """Store interaction context for persistent memory"""
        if user_id not in self.context_memory:
            self.context_memory[user_id] = []
        
        self.context_memory[user_id].append({
            "timestamp": datetime.now().isoformat(),
            "workflow": workflow_type.value,
            "context": context,
            "parameters": parameters
        })
        
        # Keep only last 10 interactions per user
        if len(self.context_memory[user_id]) > 10:
            self.context_memory[user_id] = self.context_memory[user_id][-10:]
    
    def _get_user_history(self, user_id: str) -> List[Dict]:
        """Retrieve user interaction history"""
        return self.context_memory.get(user_id, [])
    
    async def _generate_fitness_plan(
        self,
        user_context: Dict[str, Any],
        parameters: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Generate fitness plan using prompt engineering best practices
        """
        from prompt_engineering import FitnessPromptEngine
        
        prompt_engine = FitnessPromptEngine()
        enhanced_prompt = prompt_engine.create_fitness_plan_prompt(
            user_context=user_context,
            parameters=parameters,
            history=self._get_user_history(user_context.get("user_id", ""))
        )
        
        if self.client:
            response = self.client.models.generate_content(
                model="gemini-2.5-flash",
                contents=enhanced_prompt
            )
            plan_content = response.text
        else:
            plan_content = "AI client not initialized"
        
        return {
            "workflow": "fitness_plan",
            "status": "completed",
            "plan": plan_content,
            "prompt_used": enhanced_prompt,
            "timestamp": datetime.now().isoformat()
        }
    
    async def _generate_nutrition_plan(
        self,
        user_context: Dict[str, Any],
        parameters: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Generate nutrition plan with enhanced prompting
        """
        from prompt_engineering import FitnessPromptEngine
        
        prompt_engine = FitnessPromptEngine()
        enhanced_prompt = prompt_engine.create_nutrition_plan_prompt(
            user_context=user_context,
            parameters=parameters,
            history=self._get_user_history(user_context.get("user_id", ""))
        )
        
        if self.client:
            response = self.client.models.generate_content(
                model="gemini-2.5-flash",
                contents=enhanced_prompt
            )
            plan_content = response.text
        else:
            plan_content = "AI client not initialized"
        
        return {
            "workflow": "nutrition_plan",
            "status": "completed",
            "plan": plan_content,
            "prompt_used": enhanced_prompt,
            "timestamp": datetime.now().isoformat()
        }
    
    async def _handle_chat(
        self,
        user_context: Dict[str, Any],
        parameters: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Handle fitness chat with context-aware responses
        """
        from prompt_engineering import FitnessPromptEngine
        
        prompt_engine = FitnessPromptEngine()
        enhanced_prompt = prompt_engine.create_chat_prompt(
            user_context=user_context,
            message=parameters.get("message", ""),
            history=self._get_user_history(user_context.get("user_id", ""))
        )
        
        if self.client:
            response = self.client.models.generate_content(
                model="gemini-2.5-flash",
                contents=enhanced_prompt
            )
            reply = response.text
        else:
            reply = "AI client not initialized"
        
        return {
            "workflow": "chat_assistant",
            "status": "completed",
            "response": reply,
            "prompt_used": enhanced_prompt,
            "timestamp": datetime.now().isoformat()
        }
    
    async def _track_goal(
        self,
        user_context: Dict[str, Any],
        parameters: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Track and provide feedback on fitness goals
        """
        from prompt_engineering import FitnessPromptEngine
        
        prompt_engine = FitnessPromptEngine()
        enhanced_prompt = prompt_engine.create_goal_tracking_prompt(
            user_context=user_context,
            parameters=parameters,
            history=self._get_user_history(user_context.get("user_id", ""))
        )
        
        if self.client:
            response = self.client.models.generate_content(
                model="gemini-2.5-flash",
                contents=enhanced_prompt
            )
            feedback = response.text
        else:
            feedback = "AI client not initialized"
        
        return {
            "workflow": "goal_tracking",
            "status": "completed",
            "feedback": feedback,
            "prompt_used": enhanced_prompt,
            "timestamp": datetime.now().isoformat()
        }
    
    async def _provide_motivation(
        self,
        user_context: Dict[str, Any],
        parameters: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Provide motivational support and encouragement
        """
        from prompt_engineering import FitnessPromptEngine
        
        prompt_engine = FitnessPromptEngine()
        enhanced_prompt = prompt_engine.create_motivation_prompt(
            user_context=user_context,
            parameters=parameters,
            history=self._get_user_history(user_context.get("user_id", ""))
        )
        
        if self.client:
            response = self.client.models.generate_content(
                model="gemini-2.5-flash",
                contents=enhanced_prompt
            )
            motivation = response.text
        else:
            motivation = "Stay strong! Keep pushing towards your goals!"
        
        return {
            "workflow": "motivation",
            "status": "completed",
            "message": motivation,
            "prompt_used": enhanced_prompt,
            "timestamp": datetime.now().isoformat()
        }


class SimpleClawOrchestrator:
    """
    Main orchestrator for SimpleClaw-style workflows
    Zero configuration, instant deployment
    """
    
    def __init__(self, gemini_client=None):
        self.agent = SimpleCLawAgent(gemini_client)
        self.active_sessions: Dict[str, Dict[str, Any]] = {}
    
    async def start_workflow(
        self,
        user_id: str,
        workflow_type: str,
        user_data: Dict[str, Any],
        parameters: Optional[Dict[str, Any]] = None
    ) -> Dict[str, Any]:
        """
        Start a workflow - SimpleClaw style (one call, instant execution)
        """
        try:
            workflow_enum = WorkflowType(workflow_type)
        except ValueError:
            return {
                "error": f"Invalid workflow type: {workflow_type}",
                "available_workflows": [w.value for w in WorkflowType]
            }
        
        user_context = {
            "user_id": user_id,
            **user_data
        }
        
        result = await self.agent.execute_workflow(
            workflow_type=workflow_enum,
            user_context=user_context,
            parameters=parameters
        )
        
        # Store session info
        session_id = f"{user_id}_{workflow_type}_{datetime.now().timestamp()}"
        self.active_sessions[session_id] = {
            "user_id": user_id,
            "workflow": workflow_type,
            "started_at": datetime.now().isoformat(),
            "result": result
        }
        
        return {
            "session_id": session_id,
            "workflow_result": result,
            "status": "success"
        }
    
    def get_session_info(self, session_id: str) -> Optional[Dict[str, Any]]:
        """Get information about a session"""
        return self.active_sessions.get(session_id)
    
    def get_user_memory(self, user_id: str) -> List[Dict]:
        """Get user's interaction history"""
        return self.agent._get_user_history(user_id)


# Global orchestrator instance
simpleclaw_orchestrator: Optional[SimpleClawOrchestrator] = None


def get_simpleclaw_orchestrator(gemini_client=None) -> SimpleClawOrchestrator:
    """Get or create SimpleClaw orchestrator instance"""
    global simpleclaw_orchestrator
    if simpleclaw_orchestrator is None:
        simpleclaw_orchestrator = SimpleClawOrchestrator(gemini_client)
    return simpleclaw_orchestrator
