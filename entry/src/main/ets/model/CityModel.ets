/**
 * 云犀天气 - 城市数据模型
 * 定义城市信息的结构，用于城市管理功能
 */

/**
 * 代表一个城市的基本信息
 * 这个模型用于存储在收藏列表中的城市信息
 */
export interface City {
  /**
   * 城市唯一ID (通常由和风天气API提供)
   */
  id: string;

  /**
   * 城市名称 (如 "北京", "上海市黄浦区")
   */
  name: string;

  /**
   * 纬度 (用于定位或API查询)
   */
  latitude: string;

  /**
   * 经度 (用于定位或API查询)
   */
  longitude: string;

  /**
   * 是否为当前定位城市
   * 用于标识哪个城市是通过定位功能自动获取的
   */
  isLocationCity: boolean;

  /**
   * 收藏顺序 (0, 1, 2)，用于在UI上排序显示
   * 当前最多只允许收藏3个城市
   */
  order: number;

  /**
   * 添加/更新时间戳 (毫秒)
   * 用于缓存管理和排序
   */
  updateTime: number;

  /**
   * 城市所属的省/州 (可选，用于UI展示或搜索)
   */
  adm1?: string;

  /**
   * 城市所属的市/区 (可选，用于UI展示或搜索)
   */
  adm2?: string;

  /**
   * 城市所在的国家 (可选，用于UI展示或搜索)
   */
  country?: string;
}

/**
 * 代表收藏城市列表的结构
 * 这个模型用于存储和管理用户收藏的城市集合
 */
export interface CityList {
  /**
   * 城市列表数组
   */
  cities: City[];

  /**
   * 列表更新时间戳 (毫秒)
   */
  updateTime: number;
}

/**
 * 用于存储单个城市搜索结果的模型 (用于CityPage的搜索功能)
 * 这个模型通常来自API的搜索响应
 */
export interface CitySearchResult {
  id: string;      // 城市ID
  name: string;    // 城市名称 (完整名称，如 "北京市东城区")
  adm1: string;    // 省/州
  adm2: string;    // 市/区
  country: string; // 国家
  latitude: string;     // 纬度
  longitude: string;     // 经度
  tz: string;      // 时区
  // ... 其他可能的字段
}

/**
 * API 搜索城市响应结构 (简化)
 */
export interface QWeatherCitySearchResponse {
  code: string; // 状态码
  location: CitySearchResult[]; // 搜索结果数组
  refer: QWeatherRefer; // 参考信息
  // ... 其他可能的字段
}

/**
 * 和风天气API - 参考信息结构 (复用WeatherModel中的定义，或在此处定义)
 * 如果在WeatherModel中已定义，可以考虑导出并在CityModel中导入复用，
 * 但为保持文件独立性，此处也定义一份。
 */
export interface QWeatherRefer {
  sources?: string[];
  license?: string[];
  // 如果refer结构是固定的，可以在这里详细定义
  // 例如:
  // sources: string[];
  // license: string[];
}