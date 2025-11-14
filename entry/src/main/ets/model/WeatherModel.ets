/**
 * 云犀天气 - 天气数据模型
 * 定义从和风天气API获取的天气数据结构
 */

// --- 核心天气数据模型 ---
/**
 * 代表一个城市的完整天气信息
 */
export interface WeatherData {
  /**
   * 对应的城市ID
   */
  cityId: string;
  /**
   * 数据更新时间戳 (毫秒)
   */
  updateTime: number;
  /**
   * 实时天气信息
   */
  now?: NowWeather;
  /**
   * 逐小时预报 (未来48小时)
   */
  hourly?: HourlyForecast[];
  /**
   * 7天预报
   */
  daily?: DailyForecast[];
  /**
   * 空气质量信息
   */
  airQuality?: AirQualityData;
  /**
   * 健康提示信息
   */
  healthTips?: HealthTips;
  /**
   * 数据来源或备注 (可选)
   */
  source?: string;
}

/**
 * 实时天气信息
 */
export interface NowWeather {
  obsTime: string; // 观测时间 (ISO8601格式)
  temp: string;    // 实时温度 (°C)
  feelsLike: string; // 体感温度 (°C)
  text: string;    // 天气状况文字描述 (晴、阴、雨、雪等)
  icon: string;    // 天气图标代码 (和风天气API返回的数字代码)
  windDir: string; // 风向
  windScale: string; // 风力等级
  humidity: string;  // 相对湿度 (%)
  precip: string;    // 当前小时累计降水量 (mm)
  pressure: string;  // 大气压 (hPa)
  vis: string;       // 能见度 (km)
  // 可根据需要添加更多字段
}

/**
 * 逐小时预报 (未来48小时)
 */
export interface HourlyForecast {
  fxTime: string; // 预报时间 (ISO8601格式)
  temp: string;   // 温度 (°C)
  text: string;   // 天气状况文字描述
  icon: string;   // 天气图标代码
  pop: string;    // 降水概率 (%)
  // 可根据需要添加更多字段 (如风速、湿度等)
}

/**
 * 7天预报
 */
export interface DailyForecast {
  fxDate: string; // 预报日期 (yyyy-MM-dd)
  weekDay: string; // 星期几 (如 "今天", "明天", "周六")
  monthDay: string; // 月日 (如 "11/14")
  tempMax: string; // 最高温度 (°C)
  tempMin: string; // 最低温度 (°C)
  textDay: string; // 白天天气状况文字描述
  textNight: string; // 晚间天气状况文字描述
  iconDay: string; // 白天天气图标代码
  iconNight: string; // 晚间天气图标代码
  sunrise: string; // 日出时间 (hh:mm)
  sunset: string;  // 日落时间 (hh:mm)
  // 可根据需要添加更多字段 (如月相、风力等)
}

/**
 * 空气质量信息
 */
export interface AirQualityData {
  pubTime: string; // 发布时间 (ISO8601格式)
  aqi: string;     // 空气质量指数
  level: string;   // 空气质量等级 (如 "优", "良", "轻度污染")
  category: string; // 空气质量类别 (与level相同或更详细)
  primary: string; // 主要污染物
  pm2p5: string;   // PM2.5 (μg/m³)
  pm10: string;    // PM10 (μg/m³)
  so2: string;     // 二氧化硫 (μg/m³)
  no2: string;     // 二氧化氮 (μg/m³)
  o3: string;      // 臭氧 (μg/m³)
  co: string;      // 一氧化碳 (mg/m³)
  // 可根据需要添加更多字段
}

/**
 * 健康提示信息
 * 注意：和风天气API本身可能不直接提供如此详细的健康建议文本，
 * 这部分数据可能需要App内部根据天气情况生成或使用模拟数据。
 */
export interface HealthTips {
  clothing?: HealthTip; // 穿衣建议
  uv?: HealthTip;       // 紫外线/防晒建议
  travel?: HealthTip;   // 出行建议
  sport?: HealthTip;    // 运动建议
  fishing?: HealthTip;  // 钓鱼建议
  carWashing?: HealthTip; // 洗车建议
  flu?: HealthTip;      // 感冒建议
  // 可根据需要添加更多健康提示类型
}

/**
 * 单个健康提示项
 */
export interface HealthTip {
  title: string;      // 提示标题 (如 "穿衣建议")
  level: string;      // 级别 (如 "较舒适", "较不宜")
  desc: string;       // 简短描述 (如 "天气较舒适，建议穿单衣单裤等春季服装")
  detail: string;     // 详细建议 (如 "今天 25℃，穿短袖 + 薄裤子就行")
  icon: string;       // 对应图标名称 (如 "icon_clothes.png")
  // 可根据需要添加更多字段
}

// --- API 响应模型 (用于解析API返回的原始数据) ---
/**
 * 和风天气API - 实时天气响应结构 (简化)
 */
export interface QWeatherNowResponse {
  code: string; // 状态码
  now: QWeatherNowItem; // 引用具体的接口
  refer: QWeatherRefer; // 引用具体的接口
  // ... 其他可能的字段
}

/**
 * 和风天气API - 逐小时预报响应结构 (简化)
 */
export interface QWeatherHourlyResponse {
  code: string;
  hourly: QWeatherHourlyItem[]; // 数组类型
  refer: QWeatherRefer; // 引用具体的接口
  // ... 其他可能的字段
}

/**
 * 和风天气API - 7天预报响应结构 (简化)
 */
export interface QWeatherDailyResponse {
  code: string;
  daily: QWeatherDailyItem[]; // 数组类型
  refer: QWeatherRefer; // 引用具体的接口
  // ... 其他可能的字段
}

/**
 * 和风天气API - 空气质量响应结构 (简化)
 */
export interface QWeatherAirResponse {
  code: string;
  now: QWeatherAirNowItem; // 引用具体的接口
  refer: QWeatherRefer; // 引用具体的接口
  // ... 其他可能的字段
}

// --- API 响应内部结构定义 ---
/**
 * 和风天气API - 实时天气项结构
 */
export interface QWeatherNowItem {
  obsTime: string;
  temp: string;
  feelsLike: string;
  text: string;
  icon: string;
  windDir: string;
  windScale: string;
  humidity: string;
  precip: string;
  pressure: string;
  vis: string;
}

/**
 * 和风天气API - 逐小时预报项结构
 */
export interface QWeatherHourlyItem {
  fxTime: string;
  temp: string;
  text: string;
  icon: string;
  pop: string;
}

/**
 * 和风天气API - 7天预报项结构
 */
export interface QWeatherDailyItem {
  fxDate: string;
  tempMax: string;
  tempMin: string;
  textDay: string;
  textNight: string;
  iconDay: string;
  iconNight: string;
  sunrise: string;
  sunset: string;
}

/**
 * 和风天气API - 空气质量项结构
 */
export interface QWeatherAirNowItem {
  pubTime: string;
  aqi: string;
  level: string;
  category: string;
  primary: string;
  pm2p5: string;
  pm10: string;
  so2: string;
  no2: string;
  o3: string;
  co: string;
}

/**
 * 和风天气API - 参考信息结构 (通常包含API来源、许可证等)
 * 这里使用 `Record<string, any>` 是为了灵活处理可能变化的字段，
 * 但在实际使用中，如果结构固定，最好也定义为具体的接口。
 */
export interface QWeatherRefer {
  sources?: string[];
  license?: string[];
  // 如果refer结构是固定的，可以在这里详细定义
  // 例如:
  // sources: string[];
  // license: string[];
}

// --- 其他辅助模型 ---
/**
 * 用于存储单个城市搜索结果的模型 (用于CityPage的搜索功能)
 */
export interface CitySearchResult {
  id: string;      // 城市ID
  name: string;    // 城市名称
  adm1: string;    // 省/州
  adm2: string;    // 市/区
  country: string; // 国家
  lat: string;     // 纬度
  lon: string;     // 经度
  tz: string;      // 时区
  // ... 其他可能的字段
}
