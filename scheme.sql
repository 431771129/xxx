-- ============================================================
-- 1. 用户设置与状态表 (默认 0 颗星星)
-- ============================================================
DROP TABLE IF EXISTS user_profile;
CREATE TABLE user_profile (
    id INTEGER PRIMARY KEY CHECK (id = 1),
    stars INTEGER NOT NULL DEFAULT 0, -- 默认 0 颗星星
    current_grade TEXT NOT NULL DEFAULT 'preschool',
    speech_rate REAL NOT NULL DEFAULT 0.9,
    speech_pitch REAL NOT NULL DEFAULT 1.0,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO user_profile (id, stars, current_grade, speech_rate, speech_pitch)
VALUES (1, 0, 'preschool', 0.9, 1.0);


-- ============================================================
-- 2. 知识总库表 (拼音、字母、英语、古诗)
-- ============================================================
DROP TABLE IF EXISTS knowledge_library;
CREATE TABLE knowledge_library (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT NOT NULL,         -- 'pinyin' | 'alphabet' | 'english' | 'poem'
    grade_level TEXT NOT NULL,  -- 'preschool' | 'grade_1' | 'grade_2' | 'grade_3'
    title TEXT NOT NULL,        
    content TEXT NOT NULL,      
    extra_info TEXT,            
    is_active INTEGER DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2.1 全套汉语拼音卡片 (幼升小)
INSERT INTO knowledge_library (type, grade_level, title, content, extra_info) VALUES
('pinyin', 'preschool', 'a', '阿姨', '{"category":"单韵母"}'),
('pinyin', 'preschool', 'o', '噢噢', '{"category":"单韵母"}'),
('pinyin', 'preschool', 'e', '白鹅', '{"category":"单韵母"}'),
('pinyin', 'preschool', 'i', '衣服', '{"category":"单韵母"}'),
('pinyin', 'preschool', 'u', '乌龟', '{"category":"单韵母"}'),
('pinyin', 'preschool', 'ü', '小鱼', '{"category":"单韵母"}'),
('pinyin', 'preschool', 'b', '芭蕾', '{"category":"声母"}'),
('pinyin', 'preschool', 'p', '泼水', '{"category":"声母"}'),
('pinyin', 'preschool', 'm', '摸摸', '{"category":"声母"}'),
('pinyin', 'preschool', 'f', '大佛', '{"category":"声母"}'),
('pinyin', 'preschool', 'd', '得胜', '{"category":"声母"}'),
('pinyin', 'preschool', 't', '特别', '{"category":"声母"}'),
('pinyin', 'preschool', 'n', '牛奶', '{"category":"声母"}'),
('pinyin', 'preschool', 'l', '快乐', '{"category":"声母"}'),
('pinyin', 'preschool', 'g', '鸽子', '{"category":"声母"}'),
('pinyin', 'preschool', 'k', '蝌蚪', '{"category":"声母"}'),
('pinyin', 'preschool', 'h', '喝水', '{"category":"声母"}');

-- 2.2 26个英文字母卡片 (A-Z)
INSERT INTO knowledge_library (type, grade_level, title, content, extra_info) VALUES
('alphabet', 'preschool', 'A', 'Apple', '{"cn":"苹果","icon":"🍎"}'),
('alphabet', 'preschool', 'B', 'Banana', '{"cn":"香蕉","icon":"🍌"}'),
('alphabet', 'preschool', 'C', 'Cat', '{"cn":"猫","icon":"🐱"}'),
('alphabet', 'preschool', 'D', 'Dog', '{"cn":"狗","icon":"🐶"}'),
('alphabet', 'preschool', 'E', 'Egg', '{"cn":"鸡蛋","icon":"🥚"}'),
('alphabet', 'preschool', 'F', 'Fish', '{"cn":"鱼","icon":"🐟"}'),
('alphabet', 'preschool', 'G', 'Girl', '{"cn":"女孩","icon":"👧"}'),
('alphabet', 'preschool', 'H', 'Hat', '{"cn":"帽子","icon":"🎩"}'),
('alphabet', 'preschool', 'I', 'Ice', '{"cn":"冰","icon":"🧊"}'),
('alphabet', 'preschool', 'J', 'Juice', '{"cn":"果汁","icon":"🧃"}'),
('alphabet', 'preschool', 'K', 'Kite', '{"cn":"风筝","icon":"🪁"}'),
('alphabet', 'preschool', 'L', 'Lion', '{"cn":"狮子","icon":"🦁"}'),
('alphabet', 'preschool', 'M', 'Monkey', '{"cn":"猴子","icon":"🐵"}'),
('alphabet', 'preschool', 'N', 'Nest', '{"cn":"鸟巢","icon":"🪹"}'),
('alphabet', 'preschool', 'O', 'Orange', '{"cn":"桔子","icon":"🍊"}'),
('alphabet', 'preschool', 'P', 'Panda', '{"cn":"熊猫","icon":"🐼"}'),
('alphabet', 'preschool', 'Q', 'Queen', '{"cn":"女王","icon":"👑"}'),
('alphabet', 'preschool', 'R', 'Rabbit', '{"cn":"兔子","icon":"🐰"}'),
('alphabet', 'preschool', 'S', 'Sun', '{"cn":"太阳","icon":"☀️"}'),
('alphabet', 'preschool', 'T', 'Tiger', '{"cn":"老虎","icon":"🐯"}'),
('alphabet', 'preschool', 'U', 'Umbrella', '{"cn":"雨伞","icon":"☂️"}'),
('alphabet', 'preschool', 'V', 'Violin', '{"cn":"小提琴","icon":"🎻"}'),
('alphabet', 'preschool', 'W', 'Water', '{"cn":"水","icon":"💧"}'),
('alphabet', 'preschool', 'X', 'Xylophone', '{"cn":"木琴","icon":"🎼"}'),
('alphabet', 'preschool', 'Y', 'Yacht', '{"cn":"游艇","icon":"🛥️"}'),
('alphabet', 'preschool', 'Z', 'Zebra', '{"cn":"斑马","icon":"🦓"}');

-- 2.3 常用英语词句库
INSERT INTO knowledge_library (type, grade_level, title, content, extra_info) VALUES
('english', 'preschool', 'Red & Blue', '红色和蓝色', '{"icon":"🎨"}'),
('english', 'preschool', 'One, Two, Three', '一、二、三', '{"icon":"🔢"}'),
('english', 'grade_1', 'Good morning!', '早上好！', '{"icon":"🌅"}'),
('english', 'grade_1', 'How are you?', '你好吗？', '{"icon":"💬"}'),
('english', 'grade_1', 'I love my family.', '我爱我的家庭。', '{"icon":"👨‍👩‍👧"}'),
('english', 'grade_2', 'What time is it?', '现在几点了？', '{"icon":"⏰"}'),
('english', 'grade_2', 'It is a sunny day.', '今天天气晴朗。', '{"icon":"🌤️"}');

-- 2.4 丰富古诗库 (扩充至多首经典诗词)
INSERT INTO knowledge_library (type, grade_level, title, content, extra_info) VALUES
('poem', 'preschool', '咏鹅', '鹅，鹅，鹅，曲项向天歌。<br>白毛浮绿水，红掌拨清波。', '{"author":"[唐] 骆宾王","explain":"描绘了鹅在水中欢快游玩的情景。"}'),
('poem', 'preschool', '悯农', '锄禾日当午，汗滴禾下土。<br>谁知盘中餐，粒粒皆辛苦。', '{"author":"[唐] 李绅","explain":"告诉我们要珍惜粮食，体会农民伯伯的辛苦。"}'),
('poem', 'grade_1', '静夜思', '床前明月光，疑是地上霜。<br>举头望明月，低头思故乡。', '{"author":"[唐] 李白","explain":"表达了诗人对家乡和亲人的思念。"}'),
('poem', 'grade_1', '春晓', '春眠不觉晓，处处闻啼鸟。<br>夜来风雨声，花落知多少。', '{"author":"[唐] 孟浩然","explain":"描写了春天早晨美好生动的景色。"}'),
('poem', 'grade_1', '登鹳雀楼', '白日依山尽，黄河入海流。<br>欲穷千里目，更上一层楼。', '{"author":"[唐] 王之涣","explain":"鼓励人们不断努力，争取站得更高、看得更远。"}'),
('poem', 'grade_2', '赠汪伦', '李白乘舟将欲行，忽闻岸上踏歌声。<br>桃花潭水深千尺，不及汪伦送我情。', '{"author":"[唐] 李白","explain":"表达了朋友之间真挚深厚的友谊。"}'),
('poem', 'grade_2', '江雪', '千山鸟飞绝，万径人踪灭。<br>孤舟蓑笠翁，独钓寒江雪。', '{"author":"[唐] 柳宗元","explain":"展现了一幅幽静宁静的雪景钓鱼图。"}');


-- ============================================================
-- 3. 家长自定义打卡任务表
-- ============================================================
DROP TABLE IF EXISTS custom_tasks;
CREATE TABLE custom_tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    task_name TEXT NOT NULL,
    reward_stars INTEGER NOT NULL DEFAULT 1,
    is_active INTEGER DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO custom_tasks (task_name, reward_stars) VALUES
('📖 朗读5个拼音/字母卡片', 2),
('🧮 完成5道算术口算', 3),
('🧹 整理自己的玩具和书桌', 5);


-- ============================================================
-- 4. 奖励中心兑换表 (新增)
-- ============================================================
DROP TABLE IF EXISTS rewards;
CREATE TABLE rewards (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    cost_stars INTEGER NOT NULL,
    icon TEXT NOT NULL,
    is_active INTEGER DEFAULT 1
);

INSERT INTO rewards (title, cost_stars, icon) VALUES
('看动画片15分钟', 10, '📺'),
('吃一块小蛋糕', 15, '🍰'),
('去公园玩耍', 20, '🛝'),
('买一款新玩具', 50, '🧸');
