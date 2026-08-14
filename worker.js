export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const path = url.pathname;
    const method = request.method;

    const corsHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
      "Access-Control-Allow-Headers": "Content-Type",
      "Content-Type": "application/json;charset=UTF-8"
    };

    if (method === "OPTIONS") {
      return new Response(null, { headers: corsHeaders });
    }

    try {
      // 1. 获取用户信息
      if (path === "/api/profile" && method === "GET") {
        const profile = await env.DB.prepare("SELECT * FROM user_profile WHERE id = 1").first();
        return new Response(JSON.stringify(profile || { stars: 0, current_grade: 'preschool' }), { headers: corsHeaders });
      }

      // 2. 更新用户信息及星星
      if (path === "/api/profile" && method === "POST") {
        const body = await request.json();
        const { stars, current_grade, speech_rate, speech_pitch } = body;
        
        await env.DB.prepare(`
          UPDATE user_profile 
          SET stars = COALESCE(?, stars), 
              current_grade = COALESCE(?, current_grade), 
              speech_rate = COALESCE(?, speech_rate), 
              speech_pitch = COALESCE(?, speech_pitch) 
          WHERE id = 1
        `).bind(
          stars ?? null, 
          current_grade ?? null, 
          speech_rate ?? null, 
          speech_pitch ?? null
        ).run();

        return new Response(JSON.stringify({ success: true }), { headers: corsHeaders });
      }

      // 3. 拉取知识库（支持按类型/年级）
      if (path === "/api/library" && method === "GET") {
        const type = url.searchParams.get("type");
        const grade = url.searchParams.get("grade");
        
        let query = "SELECT * FROM knowledge_library WHERE is_active = 1";
        let params = [];

        if (type) {
          query += " AND type = ?";
          params.push(type);
        }
        if (grade && type !== 'alphabet' && type !== 'pinyin') {
          query += " AND grade_level = ?";
          params.push(grade);
        }

        const { results } = await env.DB.prepare(query).bind(...params).all();
        return new Response(JSON.stringify(results || []), { headers: corsHeaders });
      }

      // 4. 获取任务列表
      if (path === "/api/tasks" && method === "GET") {
        const { results } = await env.DB.prepare("SELECT * FROM custom_tasks WHERE is_active = 1").all();
        return new Response(JSON.stringify(results || []), { headers: corsHeaders });
      }

      // 5. 新增打卡任务
      if (path === "/api/tasks" && method === "POST") {
        const { task_name, reward_stars } = await request.json();
        if (!task_name) {
          return new Response(JSON.stringify({ error: "任务名称不能为空" }), { status: 400, headers: corsHeaders });
        }
        await env.DB.prepare("INSERT INTO custom_tasks (task_name, reward_stars) VALUES (?, ?)").bind(task_name, reward_stars || 1).run();
        return new Response(JSON.stringify({ success: true }), { headers: corsHeaders });
      }

      // 6. 获取奖励商城列表
      if (path === "/api/rewards" && method === "GET") {
        const { results } = await env.DB.prepare("SELECT * FROM rewards WHERE is_active = 1").all();
        return new Response(JSON.stringify(results || []), { headers: corsHeaders });
      }

      // 7. 兑换奖励扣减星星
      if (path === "/api/rewards/redeem" && method === "POST") {
        const { cost } = await request.json();
        const profile = await env.DB.prepare("SELECT stars FROM user_profile WHERE id = 1").first();
        
        if (!profile || profile.stars < cost) {
          return new Response(JSON.stringify({ error: "星星数量不足哦！" }), { status: 400, headers: corsHeaders });
        }

        const newStars = profile.stars - cost;
        await env.DB.prepare("UPDATE user_profile SET stars = ? WHERE id = 1").bind(newStars).run();
        return new Response(JSON.stringify({ success: true, newStars }), { headers: corsHeaders });
      }

      return new Response(JSON.stringify({ error: "Endpoint Not Found" }), { status: 404, headers: corsHeaders });
    } catch (err) {
      return new Response(JSON.stringify({ error: err.message }), { status: 500, headers: corsHeaders });
    }
  }
};
