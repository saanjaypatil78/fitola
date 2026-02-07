"""
MemuBot Integration for Fitola
Provides 24/7 proactive memory for adaptive, self-improving AI fitness coaching

MemuBot enables:
- Persistent memory across sessions
- Continuous learning from user interactions
- Proactive recommendations based on patterns
- Self-evolving fitness plans
"""
import os
import logging
from typing import Dict, Any, List, Optional
from datetime import datetime
from enum import Enum

logger = logging.getLogger(__name__)

# Import MemU SDK (with graceful fallback for testing without API key)
try:
    from memu_sdk import MemUClient
    MEMU_AVAILABLE = True
except ImportError:
    MEMU_AVAILABLE = False
    logger.warning("memu-py not installed. MemuBot features will use mock implementation.")


class MemoryCategory(str, Enum):
    """Memory categories for organized fitness data storage"""
    USER_PROFILE = "user_profile"          # Basic user information
    FITNESS_GOALS = "fitness_goals"        # Short and long-term goals
    WORKOUT_HISTORY = "workout_history"    # Completed workouts and performance
    NUTRITION_PREFS = "nutrition_prefs"    # Dietary preferences and restrictions
    PROGRESS_METRICS = "progress_metrics"  # Weight, measurements, achievements
    PREFERENCES = "preferences"            # User likes/dislikes
    PATTERNS = "patterns"                  # Discovered behavioral patterns
    MOTIVATIONS = "motivations"            # What motivates this user
    CHALLENGES = "challenges"              # Obstacles and how they were overcome


class MemuBotManager:
    """
    Manager for MemuBot integration with Fitola
    Handles persistent memory, learning, and proactive recommendations
    """
    
    def __init__(self, api_key: Optional[str] = None, base_url: Optional[str] = None):
        """
        Initialize MemuBot manager
        
        Args:
            api_key: MemU API key (falls back to MEMU_API_KEY env var)
            base_url: MemU API base URL (optional, for self-hosted)
        """
        self.api_key = api_key or os.getenv("MEMU_API_KEY")
        self.base_url = base_url or os.getenv("MEMU_API_BASE_URL", "https://api.memu.so")
        self.agent_id = "fitola_fitness_coach"
        
        # Initialize client if available
        if MEMU_AVAILABLE and self.api_key:
            try:
                self.client = MemUClient(
                    api_key=self.api_key,
                    base_url=self.base_url
                )
                self.enabled = True
                logger.info("MemuBot initialized successfully")
            except Exception as e:
                logger.error(f"Failed to initialize MemuBot: {e}")
                self.client = None
                self.enabled = False
        else:
            self.client = None
            self.enabled = False
            if not self.api_key:
                logger.info("MemuBot running in mock mode (no API key provided)")
            
        # Mock storage for when MemU is not available
        self.mock_memory: Dict[str, List[Dict]] = {}
    
    async def memorize_interaction(
        self,
        user_id: str,
        interaction_type: str,
        content: Dict[str, Any],
        category: MemoryCategory = MemoryCategory.USER_PROFILE
    ) -> Dict[str, Any]:
        """
        Store an interaction in long-term memory
        
        Args:
            user_id: Unique user identifier
            interaction_type: Type of interaction (e.g., "workout_completed", "goal_set")
            content: Interaction data to memorize
            category: Memory category for organization
            
        Returns:
            Dictionary with task_id and status
        """
        if self.enabled and self.client:
            try:
                # Convert interaction to conversation format for MemU
                conversation_text = self._format_for_memorization(
                    interaction_type, content
                )
                
                result = await self.client.memorize(
                    conversation=conversation_text,
                    user_id=user_id,
                    agent_id=self.agent_id,
                    wait_for_completion=False
                )
                
                logger.info(f"Memorized {interaction_type} for user {user_id}")
                return {
                    "task_id": result.task_id,
                    "status": "memorized",
                    "category": category.value
                }
            except Exception as e:
                logger.error(f"Failed to memorize interaction: {e}")
                return await self._mock_memorize(user_id, interaction_type, content, category)
        else:
            return await self._mock_memorize(user_id, interaction_type, content, category)
    
    async def retrieve_memories(
        self,
        user_id: str,
        query: str,
        category: Optional[MemoryCategory] = None,
        limit: int = 5
    ) -> List[Dict[str, Any]]:
        """
        Retrieve relevant memories for context
        
        Args:
            user_id: Unique user identifier
            query: Search query for relevant memories
            category: Optional category filter
            limit: Maximum number of memories to retrieve
            
        Returns:
            List of relevant memory items
        """
        if self.enabled and self.client:
            try:
                result = await self.client.retrieve(
                    query=query,
                    user_id=user_id,
                    agent_id=self.agent_id,
                    limit=limit
                )
                
                memories = []
                for item in result.items[:limit]:
                    memories.append({
                        "content": item.content,
                        "memory_type": item.memory_type,
                        "timestamp": item.created_at if hasattr(item, 'created_at') else None,
                        "relevance": getattr(item, 'score', 1.0)
                    })
                
                logger.info(f"Retrieved {len(memories)} memories for user {user_id}")
                return memories
            except Exception as e:
                logger.error(f"Failed to retrieve memories: {e}")
                return self._mock_retrieve(user_id, query, category, limit)
        else:
            return self._mock_retrieve(user_id, query, category, limit)
    
    async def learn_pattern(
        self,
        user_id: str,
        pattern_type: str,
        pattern_data: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Store a discovered behavioral pattern
        
        Args:
            user_id: Unique user identifier
            pattern_type: Type of pattern (e.g., "workout_preference", "motivation_trigger")
            pattern_data: Pattern details
            
        Returns:
            Result of pattern storage
        """
        pattern_content = {
            "pattern_type": pattern_type,
            "discovered_at": datetime.now().isoformat(),
            **pattern_data
        }
        
        return await self.memorize_interaction(
            user_id=user_id,
            interaction_type="pattern_learned",
            content=pattern_content,
            category=MemoryCategory.PATTERNS
        )
    
    async def get_proactive_suggestions(
        self,
        user_id: str,
        context: Dict[str, Any]
    ) -> List[Dict[str, Any]]:
        """
        Get proactive suggestions based on user's memory and patterns
        
        Args:
            user_id: Unique user identifier
            context: Current context (time, activity, mood, etc.)
            
        Returns:
            List of proactive suggestions
        """
        # Retrieve relevant patterns and preferences
        patterns = await self.retrieve_memories(
            user_id=user_id,
            query=f"behavioral patterns and preferences",
            category=MemoryCategory.PATTERNS
        )
        
        preferences = await self.retrieve_memories(
            user_id=user_id,
            query=f"user preferences and likes",
            category=MemoryCategory.PREFERENCES
        )
        
        # Generate suggestions based on patterns
        suggestions = self._generate_suggestions(patterns, preferences, context)
        
        return suggestions
    
    async def update_goal_progress(
        self,
        user_id: str,
        goal: str,
        progress: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Update progress on a fitness goal
        
        Args:
            user_id: Unique user identifier
            goal: Goal description
            progress: Progress data
            
        Returns:
            Result with adaptive recommendations
        """
        # Memorize progress
        await self.memorize_interaction(
            user_id=user_id,
            interaction_type="goal_progress_update",
            content={"goal": goal, **progress},
            category=MemoryCategory.PROGRESS_METRICS
        )
        
        # Retrieve goal history
        history = await self.retrieve_memories(
            user_id=user_id,
            query=f"progress on {goal}",
            category=MemoryCategory.PROGRESS_METRICS
        )
        
        # Analyze and adapt
        analysis = self._analyze_progress(goal, progress, history)
        
        return analysis
    
    def _format_for_memorization(
        self,
        interaction_type: str,
        content: Dict[str, Any]
    ) -> str:
        """Format interaction data for MemU conversation format"""
        return f"User Action: {interaction_type}\nDetails: {str(content)}"
    
    def _generate_suggestions(
        self,
        patterns: List[Dict],
        preferences: List[Dict],
        context: Dict[str, Any]
    ) -> List[Dict[str, Any]]:
        """Generate proactive suggestions from patterns and preferences"""
        suggestions = []
        
        # Time-based suggestions
        current_hour = datetime.now().hour
        if 6 <= current_hour <= 9:
            suggestions.append({
                "type": "workout",
                "title": "Morning Workout",
                "reason": "Based on your usual morning routine",
                "confidence": 0.8
            })
        elif 17 <= current_hour <= 20:
            suggestions.append({
                "type": "workout",
                "title": "Evening Exercise",
                "reason": "Your typical workout window",
                "confidence": 0.7
            })
        
        # Pattern-based suggestions
        for pattern in patterns:
            if "workout" in pattern.get("content", "").lower():
                suggestions.append({
                    "type": "insight",
                    "title": "Detected Pattern",
                    "reason": pattern.get("content", ""),
                    "confidence": pattern.get("relevance", 0.6)
                })
        
        return suggestions[:3]  # Top 3 suggestions
    
    def _analyze_progress(
        self,
        goal: str,
        progress: Dict[str, Any],
        history: List[Dict]
    ) -> Dict[str, Any]:
        """Analyze progress and generate adaptive recommendations"""
        
        # Calculate trend
        if len(history) >= 2:
            trend = "improving"  # Simplified - would analyze actual metrics
        else:
            trend = "new"
        
        return {
            "goal": goal,
            "current_progress": progress,
            "trend": trend,
            "adaptive_recommendation": self._get_adaptive_recommendation(trend, progress),
            "history_count": len(history)
        }
    
    def _get_adaptive_recommendation(
        self,
        trend: str,
        progress: Dict[str, Any]
    ) -> str:
        """Generate adaptive recommendation based on progress trend"""
        if trend == "improving":
            return "Great progress! Consider increasing intensity by 10% next week."
        elif trend == "plateau":
            return "Try varying your routine or adding new exercises to break the plateau."
        else:
            return "Stay consistent! Building habits takes time."
    
    # Mock implementations for testing without API key
    
    async def _mock_memorize(
        self,
        user_id: str,
        interaction_type: str,
        content: Dict[str, Any],
        category: MemoryCategory
    ) -> Dict[str, Any]:
        """Mock memorization for testing"""
        if user_id not in self.mock_memory:
            self.mock_memory[user_id] = []
        
        memory_item = {
            "interaction_type": interaction_type,
            "content": content,
            "category": category.value,
            "timestamp": datetime.now().isoformat()
        }
        
        self.mock_memory[user_id].append(memory_item)
        
        return {
            "task_id": f"mock_{len(self.mock_memory[user_id])}",
            "status": "memorized_mock",
            "category": category.value
        }
    
    def _mock_retrieve(
        self,
        user_id: str,
        query: str,
        category: Optional[MemoryCategory],
        limit: int
    ) -> List[Dict[str, Any]]:
        """Mock retrieval for testing"""
        if user_id not in self.mock_memory:
            return []
        
        memories = self.mock_memory[user_id]
        
        # Simple filtering
        if category:
            memories = [m for m in memories if m.get("category") == category.value]
        
        # Return most recent
        return memories[-limit:] if len(memories) > limit else memories
    
    async def close(self):
        """Close MemU client connection"""
        if self.enabled and self.client:
            try:
                await self.client.close()
            except Exception as e:
                logger.error(f"Error closing MemU client: {e}")


# Global manager instance
memubot_manager: Optional[MemuBotManager] = None


def get_memubot_manager() -> MemuBotManager:
    """Get or create MemuBot manager instance"""
    global memubot_manager
    if memubot_manager is None:
        memubot_manager = MemuBotManager()
    return memubot_manager
