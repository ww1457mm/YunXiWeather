/**
 * 天气数据模型
 */
import { City } from './CityModel'; // 导入已定义的City接口
// 当前天气状况
export interface WeatherNow {
  temp: string;        // 当前温度
  feelsLike: string;   // 体感温度
  text: string;        // 天气状况文本（晴、多云等）
  icon: string;        // 天气图标代码
  humidity: string;    // 湿度（百分比）
  windDir: string;     // 风向
  windScale: string;   // 风力等级
  pressure: string;    // 气压
  visibility: string;  // 能见度
  cloud: string;       // 云量
}

// 逐小时预报
export interface HourlyForecast {
  time: string;        // 时间（格式：HH:mm）
  temp: string;        // 温度
  feelsLike: string;   // 体感温度
  text: string;        // 天气状况
  icon: string;        // 天气图标
  humidity: string;    // 湿度
  windDir: string;     // 风向
  windScale: string;   // 风力
  pop: string;         // 降水概率（百分比）
}

// 逐天预报
export interface DailyForecast {
  date: string;        // 日期（格式：MM/DD）
  dayText: string;     // 白天天气状况
  nightText: string;   // 夜间天气状况
  dayIcon: string;     // 白天天气图标
  nightIcon: string;   // 夜间天气图标
  tempMax: string;     // 最高温度
  tempMin: string;     // 最低温度
  humidity: string;    // 湿度
  windDir: string;     // 风向
  windScale: string;   // 风力
  uvIndex: string;     // 紫外线指数
  rainfall: string;    // 降雨量
}

// 空气质量
export interface AirQuality {
  aqi: string;         // AQI指数
  category: string;    // 等级类别（优、良等）
  primary: string;     // 主要污染物
  pm25: string;        // PM2.5
  pm10: string;        // PM10
  no2: string;         // 二氧化氮
  so2: string;         // 二氧化硫
  co: string;          // 一氧化碳
  o3: string;          // 臭氧
  timestamp: string;   // 数据更新时间
}

// 健康提示
export interface HealthTip {
  type: string;        // 提示类型（clothes, umbrella等）
  title: string;       // 标题
  content: string;     // 详细内容
  icon: string;        // 图标标识
  isValid: boolean;    // 是否有效（根据天气条件判断）
}

// 完整的天气数据结构
export interface WeatherData {
  now: WeatherNow;                   // 当前天气
  hourly: HourlyForecast[];          // 逐小时预报
  daily: DailyForecast[];            // 逐天预报
  airQuality: AirQuality;            // 空气质量
  healthTips: HealthTip[];           // 健康提示

  updateTime: string;                // 数据更新时间
  isCached: boolean;                 // 是否为缓存数据
}