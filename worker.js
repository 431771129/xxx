export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const path = url.pathname;
    const method = request.method;

    // CORS 跨域请求头（允许前端页面跨域调用 API）
    const corsHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
      "Access-Control-Allow-Headers": "Content-Type",
      "Content-Type": "application/json;charset=UTF-8"
    };

    // 处理浏览器跨域预检请求 (Preflight)
    if (method === "OPTIONS") {
      return new Response(null, { headers: corsHeaders });
    }

    try {
      // ------------------------------------------------------------
      // 1. 获取当前用户基本信息（年级、星星数、TTS语调）
      // ------------------------------------------------------------
      if (path === "/api/profile" && method === "GET") {
        const profile = await env.DB.prepare("SELECT * FROM user_profile WHERE id = 1").first();
        return new Response(JSON.stringify(profile || {}), { headers: corsHeaders });
      }

      // ------------------------------------------------------------
      // 2. 更新用户设置/星星数量/修改年级
      // ------------------------------------------------------------
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
        `).bind(stars, current_grade, speech_rate, speech_pitch).run();

        return new Response(JSON.stringify({ success: true }), { headers: corsHeaders });
      }

      // ------------------------------------------------------------
      // 3. 根据类型和年级拉取知识库数据 (拼音/英语/古诗)
      // ------------------------------------------------------------
      if (path === "/api/library" && method === "GET") {
        const type = url.searchParams.get("type");
        const grade = url.searchParams.get("grade");
        
        let query = "SELECT * FROM knowledge_library WHERE is_active = 1";
        let params = [];

        if (type) {
          query += " AND type = ?";
          params.push(type);
        }
        if (grade) {
          query += " AND grade_level = ?";
          params.push(grade);
        }

        const { results } = await env.DB.prepare(query).bind(...params).all();
        return new Response(JSON.stringify(results), { headers: corsHeaders });
      }

      // ------------------------------------------------------------
      // 4. 获取家长打卡任务列表
      // ------------------------------------------------------------
      if (path === "/api/tasks" && method === "GET") {
        const { results } = await env.DB.prepare("SELECT * FROM custom_tasks WHERE is_active = 1").all();
        return new Response(JSON.stringify(results), { headers: corsHeaders });
      }

      // ------------------------------------------------------------
      // 5. 家长新增打卡任务
      // ------------------------------------------------------------
      if (path === "/api/tasks" && method === "POST") {
        const { task_name, reward_stars } = await request.json();
        await env.DB.prepare("INSERT INTO custom_tasks (task_name, reward_stars) VALUES (?, ?)").bind(task_name, reward_stars).run();
        return new Response(JSON.stringify({ success: true }), { headers: corsHeaders });
      }

      // ------------------------------------------------------------
      // 6. 记录孩子算术错题
      // ------------------------------------------------------------
      if (path === "/api/mistakes" && method === "POST") {
        const { question, wrong_answer } = await request.json();
        await env.DB.prepare("INSERT INTO mistake_records (question, wrong_answer) VALUES (?, ?)").bind(question, wrong_answer).run();
        return new Response(JSON.stringify({ success: true }), { headers: corsHeaders });
      }

      // ------------------------------------------------------------
      // 7. 家长获取错题本
      // ------------------------------------------------------------
      if (path === "/api/mistakes" && method === "GET") {
        const { results } = await env.DB.prepare("SELECT * FROM mistake_records ORDER BY created_at DESC LIMIT 20").all();
        return new Response(JSON.stringify(results), { headers: corsHeaders });
      }

      return new Response(JSON.stringify({ error: "Endpoint Not Found" }), { status: 404, headers: corsHeaders });
    } catch (err) {
      return new Response(JSON.stringify({ error: err.message }), { status: 500, headers: corsHeaders });
    }
  }
};
