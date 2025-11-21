/**
 * 城市数据模型定义
 */

export interface City {
  id: string;            // 城市唯一标识
  name: string;          // 城市名称
  locationCity: boolean; // 是否为定位城市
  favoriteOrder: number; // 收藏顺序(0表示未收藏，1-3表示收藏顺序)
  latitude?: number;     // 纬度(可选)
  longitude?: number;    // 经度(可选)
  province?: string;     // 省份(可选)
  updateTime?: string;   // 更新时间(可选)
}

// 城市列表响应接口
export interface CityListResponse {
  success: boolean;      // 请求是否成功
  code: number;          // 错误码
  message: string;       // 消息
  data: City[];          // 城市列表
}