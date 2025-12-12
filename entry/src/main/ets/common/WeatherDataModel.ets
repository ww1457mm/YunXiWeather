/**
 * 天气数据模型定义
 */

// 实时天气数据模型
export class CurrentWeather {
  cityName: string = '';
  weatherCondition: string = ''; // 天气状况描述
  temperature: number = 0; // 实时温度
  feelsLike: number = 0; // 体感温度
  humidity: number = 0; // 湿度
  windSpeed: number = 0; // 风速
  windDirection: string = ''; // 风向
  pressure: number = 0; // 气压
  visibility: number = 0; // 能见度
  aqi: number = 0; // 空气质量指数
  aqiLevel: number = 0; // 空气质量等级
  aqiDescription: string = ''; // 空气质量描述
  updateTime: string = ''; // 更新时间
}

// 小时预报数据模型
export class HourlyForecast {
  time: string = ''; // 时间
  temperature: number = 0; // 温度
  weatherCondition: string = ''; // 天气状况
  precipitation: number = 0; // 降水量
}

// 日预报数据模型
export class DailyForecast {
  date: string = ''; // 日期
  weekDay: string = ''; // 星期
  weatherCondition: string = ''; // 天气状况
  maxTemperature: number = 0; // 最高温度
  minTemperature: number = 0; // 最低温度
  aqi: number = 0; // 空气质量指数
  aqiLevel: number = 0; // 空气质量等级
  aqiDescription: string = ''; // 空气质量描述
  sunrise: string = ''; // 日出时间
  sunset: string = ''; // 日落时间
}

// 空气质量数据模型
export class AirQuality {
  pm25: number = 0; // PM2.5
  pm10: number = 0; // PM10
  so2: number = 0; // SO2
  no2: number = 0; // NO2
  o3: number = 0; // O3
  co: number = 0; // CO
  aqi: number = 0; // AQI
  level: number = 0; // 等级
  quality: string = ''; // 质量描述
  primaryPollutant: string = ''; // 主要污染物
  advice: string = ''; // 建议
}

// 生活指数数据模型
export class LifeIndex {
  clothes: LifeIndexItem = new LifeIndexItem(); // 穿衣指数
  umbrella: LifeIndexItem = new LifeIndexItem(); // 雨伞指数
  sports: LifeIndexItem = new LifeIndexItem(); // 运动指数
  carWash: LifeIndexItem = new LifeIndexItem(); // 洗车指数
  coldRisk: LifeIndexItem = new LifeIndexItem(); // 感冒指数
  fishing: LifeIndexItem = new LifeIndexItem(); // 钓鱼指数
  sunscreen: LifeIndexItem = new LifeIndexItem(); // 防晒指数
}

// 单个生活指数项
export class LifeIndexItem {
  level: string = ''; // 等级
  description: string = ''; // 描述
  advice: string = ''; // 建议
}

// 极端天气预警数据模型
export class ExtremeWeatherWarning {
  id: string = ''; // 预警ID
  sender: string = ''; // 发布单位
  pubTime: string = ''; // 发布时间
  title: string = ''; // 标题
  level: string = ''; // 预警等级
  type: string = ''; // 预警类型
  description: string = ''; // 预警描述
  startTime: string = ''; // 开始时间
  endTime: string = ''; // 结束时间
}

// 城市信息数据模型
export class CityInfo {
  id: string = ''; // 城市ID
  name: string = ''; // 城市名称
  latitude: number = 0; // 纬度
  longitude: number = 0; // 经度
  isFavorite: boolean = false; // 是否收藏
}