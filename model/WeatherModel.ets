/**
 * 天气数据模型定义
 */

// 空气质量数据接口
export interface AirQualityData {
  aqi: number;           // 空气质量指数
  pm25: number;          // PM2.5浓度
  pm10: number;          // PM10浓度
  so2: number;           // 二氧化硫浓度
  no2: number;           // 二氧化氮浓度
  o3: number;            // 臭氧浓度
  co: number;            // 一氧化碳浓度
  level: number;         // 空气质量等级(1-6)
  levelDesc: string;     // 空气质量等级描述
  color: string;         // 等级对应颜色
  primaryPollutant: string; // 首要污染物
  updateTime: string;    // 更新时间
}

// 逐小时预报数据接口
export interface ForecastHourly {
  time: string;          // 预报时间(YYYY-MM-DD HH:mm)
  temperature: number;   // 温度(℃)
  weather: string;       // 天气状况
  weatherIcon: string;   // 天气图标
  humidity: number;      // 湿度(%)
  precipitation: number; // 降水量(mm)
  windDirection: string; // 风向
  windSpeed: number;     // 风速(km/h)
  uvIndex: number;       // 紫外线指数
}

// 逐日预报数据接口
export interface ForecastDaily {
  date: string;          // 日期(YYYY-MM-DD)
  week: string;          // 星期
  maxTemp: number;       // 最高温度
  minTemp: number;       // 最低温度
  weatherDay: string;    // 白天天气
  weatherNight: string;  // 夜间天气
  weatherIconDay: string;// 白天天气图标
  weatherIconNight: string; // 夜间天气图标
  sunrise: string;       // 日出时间
  sunset: string;        // 日落时间
  moonrise: string;      // 月出时间
  moonset: string;       // 月落时间
  uvIndex: number;       // 紫外线指数
  precipitation: number; // 降水量(mm)
  humidity: number;      // 湿度(%)
  windDirection: string; // 风向
  windSpeed: number;     // 风速(km/h)
}

// 健康提示接口
export interface HealthTips {
  uv: string;            // 紫外线提示
  temperature: string;   // 温度提示
  clothing: string;      // 穿衣提示
  cold: string;          // 感冒提示
  sport: string;         // 运动提示
  carWash: string;       // 洗车提示
  air: string;           // 空气污染扩散条件提示
}

// 实时天气数据接口
export interface RealTimeWeather {
  city: string;          // 城市名称
  temperature: number;   // 当前温度
  weather: string;       // 当前天气
  weatherIcon: string;   // 天气图标
  feelsLike: number;     // 体感温度
  humidity: number;      // 湿度(%)
  precipitation: number; // 降水量(mm)
  windDirection: string; // 风向
  windSpeed: number;     // 风速(km/h)
  windScale: number;     // 风力等级
  pressure: number;      // 气压(hPa)
  visibility: number;    // 能见度(km)
  uvIndex: number;       // 紫外线指数
  updateDateTime: string;// 更新时间
}

// 天气数据主接口
export interface WeatherData {
  cityId: string;        // 城市ID
  realTime: RealTimeWeather;     // 实时天气
  hourlyForecast: ForecastHourly[]; // 逐小时预报
  dailyForecast: ForecastDaily[];   // 7天预报
  airQuality: AirQualityData;    // 空气质量
  healthTips: HealthTips;        // 健康提示
  lastUpdateTime: string;        // 最后更新时间
  expiresAt: string;             // 缓存过期时间
}

// 天气数据响应接口
export interface WeatherResponse {
  success: boolean;              // 请求是否成功
  code: number;                  // 错误码
  message: string;               // 消息
  data: WeatherData;             // 天气数据
}