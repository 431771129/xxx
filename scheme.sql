-- ============================================================
-- 1. 用户设置与状态表 (user_profile)
-- 仅保留单条记录（id=1），存储孩子当前的星星数、选定年级与语音参数
-- ============================================================
DROP TABLE IF EXISTS user_profile;
CREATE TABLE user_profile (
    id INTEGER PRIMARY KEY CHECK (id = 1),
    stars INTEGER NOT NULL DEFAULT 10,
    current_grade TEXT NOT NULL DEFAULT 'preschool', -- preschool | grade_1 | grade_2 | grade_3
    speech_rate REAL NOT NULL DEFAULT 0.9,
    speech_pitch REAL NOT NULL DEFAULT 1.0,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 初始化默认用户数据
INSERT INTO user_profile (id, stars, current_grade, speech_rate, speech_pitch)
VALUES (1, 10, 'preschool', 0.9, 1.0);


-- ============================================================
-- 2. 云端知识总库表 (knowledge_library)
-- 统一存储拼音、英语词句、古诗词，绑定年级标签与 JSON 结构化扩展信息
-- ============================================================
DROP TABLE IF EXISTS knowledge_library;
CREATE TABLE knowledge_library (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT NOT NULL,         -- 'pinyin' | 'english' | 'poem'
    grade_level TEXT NOT NULL,  -- 'preschool' | 'grade_1' | 'grade_2' | 'grade_3'
    title TEXT NOT NULL,        -- 拼音字母 / 英文单词 / 古诗标题
    content TEXT NOT NULL,      -- 拼音词组 / 中文翻译 / 古诗正文
    extra_info TEXT,            -- JSON 扩展字段 (如图标 icon、作者 author、诗意解读 explain)
    is_active INTEGER DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------
-- 2.1 预置：拼音数据 (幼升小阶段)
-- ------------------------------------------------------------
INSERT INTO knowledge_library (type, grade_level, title, content, extra_info) VALUES
('pinyin', 'preschool', 'a', '阿姨', '{"category":"单韵母"}'),
('pinyin', 'preschool', 'o', '噢噢', '{"category":"单韵母"}'),
('pinyin', 'preschool', 'e', '白鹅', '{"category":"单韵母"}'),
('pinyin', 'preschool', 'i', '衣服', '{"category":"单韵母"}'),
('pinyin', 'preschool', 'u', '乌龟', '{"category":"单韵母"}'),
('pinyin', 'preschool', 'ü', '小鱼', '{"category":"单韵母"}'),
('pinyin', 'preschool', 'b', '芭蕾', '{"category":"声母"}'),
('pinyin', 'preschool', 'p', '泼水', '{"category":"声母"}'),
('pinyin', 'preschool', 'm', '摸摸', '{"category":"声母"}');

-- ------------------------------------------------------------
-- 2.2 预置：英语单词/句子 (分年级)
-- ------------------------------------------------------------
-- 幼升小 (preschool)
INSERT INTO knowledge_library (type, grade_level, title, content, extra_info) VALUES
('english', 'preschool', 'apple', '苹果', '{"icon":"🍎"}'),
('english', 'preschool', 'cat', '猫', '{"icon":"🐱"}'),
('english', 'preschool', 'dog', '狗', '{"icon":"🐶"}'),
('english', 'preschool', 'sun', '太阳', '{"icon":"☀️"}');

-- 一年级 (grade_1)
INSERT INTO knowledge_library (type, grade_level, title, content, extra_info) VALUES
('english', 'grade_1', 'book', '书本', '{"icon":"📖"}'),
('english', 'grade_1', 'pencil', '铅笔', '{"icon":"✏️"}'),
('english', 'grade_1', 'Good morning!', '早上好！', '{"icon":"🌅"}'),
('english', 'grade_1', 'How are you?', '你好吗？', '{"icon":"💬"}');

-- 二年级 (grade_2)
INSERT INTO knowledge_library (type, grade_level, title, content, extra_info) VALUES
('english', 'grade_2', 'family', '家庭', '{"icon":"👨‍👩‍👧"}'),
('english', 'grade_2', 'weather', '天气', '{"icon":"🌤️"}'),
('english', 'grade_2', 'I like apples.', '我喜欢苹果。', '{"icon":"😋"}');

-- 三年级 (grade_3)
INSERT INTO knowledge_library (type, grade_level, title, content, extra_info) VALUES
('english', 'grade_3', 'season', '季节', '{"icon":"🍂"}'),
('english', 'grade_3', 'Where is the station?', '车站怎么走？', '{"icon":"🚉"}');

-- ------------------------------------------------------------
-- 2.3 预置：经典古诗 (分年级)
-- ------------------------------------------------------------
-- 幼升小 (preschool)
INSERT INTO knowledge_library (type, grade_level, title, content, extra_info) VALUES
('poem', 'preschool', '咏鹅', '鹅，鹅，鹅，曲项向天歌。<br>白毛浮绿水，红掌拨清波。', '{"author":"[唐] 骆宾王","explain":"描绘了鹅在水中欢快游玩的情景，弯着脖子朝天歌唱。"}');

-- 一年级 (grade_1)
INSERT INTO knowledge_library (type, grade_level, title, content, extra_info) VALUES
('poem', 'grade_1', '静夜思', '床前明月光，疑是地上霜。<br>举头望明月，低头思故乡。', '{"author":"[唐] 李白","explain":"诗人看到窗前的明月，表达了对家乡和亲人的思念。"}'),
('poem', 'grade_1', '春晓', '春眠不觉晓，处处闻啼鸟。<br>夜来风雨声，花落知多少。', '{"author":"[唐] 孟浩然","explain":"描写了春天早晨刚睡醒时听到的鸟鸣与对夜晚风雨落花的想象。"}');

-- 二年级 (grade_2)
INSERT INTO knowledge_library (type, grade_level, title, content, extra_info) VALUES
('poem', 'grade_2', '赠汪伦', '李白乘舟将欲行，忽闻岸上踏歌声。<br>桃花潭水深千尺，不及汪伦送我情。', '{"author":"[唐] 李白","explain":"表达了李白与朋友汪伦之间深厚真挚的友谊。"}');

-- 三年级 (grade_3)
INSERT INTO knowledge_library (type, grade_level, title, content, extra_info) VALUES
('poem', 'grade_3', '望庐山瀑布', '日照香炉生紫烟，遥看瀑布挂前川。<br>飞流直下三千尺，疑是银河落九天。', '{"author":"[唐] 李白","explain":"展现了庐山瀑布极为壮丽震撼的自然景观。"}');


-- ============================================================
-- 3. 家长自定义打卡任务表 (custom_tasks)
-- ============================================================
DROP TABLE IF EXISTS custom_tasks;
CREATE TABLE custom_tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    task_name TEXT NOT NULL,
    reward_stars INTEGER NOT NULL DEFAULT 1,
    is_active INTEGER DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 初始化默认任务
INSERT INTO custom_tasks (task_name, reward_stars) VALUES
('📖 朗读10个拼音或单词', 2),
('🧮 完成5道算术练习', 3),
('🧹 整理自己的书桌', 5);


-- ============================================================
-- 4. 算术错题记录表 (mistake_records)
-- ============================================================
DROP TABLE IF EXISTS mistake_records;
CREATE TABLE mistake_records (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    question TEXT NOT NULL,
    wrong_answer TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
