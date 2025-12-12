/**
 * 和风天气API接口封装（修正版）
 * API密钥: b30abe309e99457cbf320e9806aeec41
 * 核心修正：1. 替换为官方合法域名 2. 修复URL拼接逻辑 3. 修正地理编码接口 4. 增加日志/容错
 */
import { CurrentWeather, HourlyForecast, DailyForecast, AirQuality, LifeIndex, LifeIndexItem, ExtremeWeatherWarning, CityInfo } from './WeatherDataModel'
import http from '@ohos.net.http'
import hilog from '@ohos.hilog' // 新增：导入日志模块，方便排查

// ========== 使用专属API Host，提供更高安全性 ==========
const API_HOST = 'https://mg78kym3r3.re.qweatherapi.com' // 专属API Host
const BASE_URL = `${API_HOST}/v7` // 天气API V7
const GEO_URL = API_HOST // 地理编码API使用同一Host
const KEY = 'b30abe309e99457cbf320e9806aeec41' // API Key（正确密钥）

/**
 * 封装HTTP请求（新增：打印请求URL，增加容错）
 * @param url 请求URL
 * @returns Promise<any>
 */
async function httpRequest(url: string): Promise<Record<string, Object>> {
  const httpRequest = http.createHttp()
  try {
    // 新增：打印请求URL，方便排查拼接错误
    hilog.info(0x0000, 'WeatherAPI', `请求URL: ${url}`);

    const response = await httpRequest.request(url, {
      method: http.RequestMethod.GET,
      header: {
        'Content-Type': 'application/json'
      },
      connectTimeout: 60000,
      readTimeout: 60000
    })

    if (response.responseCode === 200) {
      const resultStr = typeof response.result === 'string' ? response.result : response.result.toString()
      hilog.info(0x0000, 'WeatherAPI', `响应内容: ${resultStr.substring(0, 200)}`); // 打印前200个字符
      const result: Record<string, Object> = JSON.parse(resultStr) as Record<string, Object>
      return result
    } else {
      // 读取错误响应体
      const errorStr = typeof response.result === 'string' ? response.result : response.result.toString()
      hilog.error(0x0000, 'WeatherAPI', `HTTP ${response.responseCode} - 响应: ${errorStr}`);
      throw new Error(`HTTP Error: ${response.responseCode}`)
    }
  } catch (error) {
    hilog.error(0x0000, 'WeatherAPI', `请求失败: ${(error as Error).message}`);
    throw new Error((error as Error).message || '未知错误');

  } finally {
    httpRequest.destroy()
  }
}

/**
 * 获取实时天气数据（修正：URL拼接逻辑）
 * @param location 城市ID或经纬度格式：纬度,经度（lat,lon）
 * @returns Promise<CurrentWeather>
 */
export async function getCurrentWeather(location: string): Promise<CurrentWeather> {
  try {
    // 修正：BASE_URL仅保留基础路径，接口路径单独拼接
    const url = `${BASE_URL}/weather/now?location=${location}&key=${KEY}`
    const data = await httpRequest(url)

    if (data.code === '200') {
      const weather = new CurrentWeather()
      // 新增：容错处理，避免字段为空导致报错
      const locationData = data.location as Record<string, Object> || {}
      const nowData = data.now as Record<string, Object> || {}

      weather.cityName = (locationData.name as string) || ''
      weather.weatherCondition = (nowData.text as string) || ''
      weather.temperature = parseInt(nowData.temp as string) || 0
      weather.feelsLike = parseInt(nowData.feelsLike as string) || 0
      weather.humidity = parseInt(nowData.humidity as string) || 0
      weather.windSpeed = parseInt(nowData.windSpeed as string) || 0
      weather.windDirection = (nowData.windDir as string) || ''
      weather.pressure = parseInt(nowData.pressure as string) || 0
      weather.visibility = parseInt(nowData.vis as string) || 0
      weather.updateTime = (data.updateTime as string) || ''

      return weather
    } else {
      throw new Error(`API Error: ${data.code} - ${data.msg || '无描述'}`)
    }
  } catch (error) {
    throw new Error(`获取实时天气失败: ${(error as Error).message}`)
  }
}

/**
 * 获取小时预报数据（修正：URL拼接逻辑）
 * @param location 城市ID或经纬度格式：纬度,经度（lat,lon）
 * @param hours 小时数，默认24小时
 * @returns Promise<HourlyForecast[]>
 */
export async function getHourlyForecast(location: string, hours: number = 24): Promise<HourlyForecast[]> {
  try {
    const url = `${BASE_URL}/weather/24h?location=${location}&key=${KEY}`
    const data = await httpRequest(url)

    if (data.code === '200') {
      const forecasts: HourlyForecast[] = []
      const hourlyData = (data.hourly as Array<Record<string, Object>>) || []

      for (let i = 0; i < Math.min(hourlyData.length, hours); i++) {
        const item = hourlyData[i] || {}
        const forecast = new HourlyForecast()
        forecast.time = (item.fxTime as string) || ''
        forecast.temperature = parseInt(item.temp as string) || 0
        forecast.weatherCondition = (item.text as string) || ''
        forecast.precipitation = parseFloat(item.precip as string) || 0
        forecasts.push(forecast)
      }

      return forecasts
    } else {
      throw new Error(`API Error: ${data.code} - ${data.msg || '无描述'}`)
    }
  } catch (error) {
    throw new Error(`获取小时预报失败: ${(error as Error).message}`)
  }
}

/**
 * 获取日预报数据（修正：URL拼接逻辑）
 * @param location 城市ID或经纬度格式：纬度,经度（lat,lon）
 * @param days 天数，默认7天
 * @returns Promise<DailyForecast[]>
 */
export async function getDailyForecast(location: string, days: number = 7): Promise<DailyForecast[]> {
  try {
    const url = `${BASE_URL}/weather/7d?location=${location}&key=${KEY}`
    const data = await httpRequest(url)

    if (data.code === '200') {
      const forecasts: DailyForecast[] = []
      const dailyData = (data.daily as Array<Record<string, Object>>) || []

      for (let i = 0; i < Math.min(dailyData.length, days); i++) {
        const item = dailyData[i] || {}
        const forecast = new DailyForecast()
        forecast.date = (item.fxDate as string) || ''
        forecast.weatherCondition = (item.textDay as string) || ''
        forecast.maxTemperature = parseInt(item.tempMax as string) || 0
        forecast.minTemperature = parseInt(item.tempMin as string) || 0
        forecast.sunrise = (item.sunrise as string) || ''
        forecast.sunset = (item.sunset as string) || ''
        forecasts.push(forecast)
      }

      return forecasts
    } else {
      throw new Error(`API Error: ${data.code} - ${data.msg || '无描述'}`)
    }
  } catch (error) {
    throw new Error(`获取日预报失败: ${(error as Error).message}`)
  }
}

/**
 * 获取空气质量数据（使用V1 API，精度1x1公里）
 * @param latitude 纬度
 * @param longitude 经度
 * @returns Promise<AirQuality>
 */
export async function getAirQuality(latitude: number, longitude: number): Promise<AirQuality> {
  try {
    // 使用空气质量V1 API，需要经纬度参数
    const lat = latitude.toFixed(2)
    const lon = longitude.toFixed(2)
    const url = `${API_HOST}/airquality/v1/current/${lat}/${lon}?key=${KEY}`
    const data = await httpRequest(url)

    const airQuality = new AirQuality()
    
    // V1 API返回的是indexes和pollutants数组
    const indexes = (data.indexes as Array<Record<string, Object>>) || []
    const pollutants = (data.pollutants as Array<Record<string, Object>>) || []
    
    // 获取美国EPA标准的AQI（或者QAQI）
    const usEpaIndex = indexes.find((idx: Record<string, Object>) => idx.code === 'us-epa') ||
                       indexes.find((idx: Record<string, Object>) => idx.code === 'qaqi') ||
                       indexes[0] || {}
    
    airQuality.aqi = parseInt(usEpaIndex.aqi as string) || 0
    airQuality.level = parseInt(usEpaIndex.level as string) || 0
    airQuality.quality = (usEpaIndex.category as string) || ''
    
    // 获取首要污染物
    const primaryPollutant = usEpaIndex.primaryPollutant as Record<string, Object> || {}
    airQuality.primaryPollutant = (primaryPollutant.name as string) || ''
    
    // 获取健康建议
    const health = usEpaIndex.health as Record<string, Object> || {}
    const advice = health.advice as Record<string, Object> || {}
    airQuality.advice = (advice.generalPopulation as string) || ''
    
    // 解析污染物浓度值
    pollutants.forEach((pollutant: Record<string, Object>) => {
      const code = pollutant.code as string
      const concentration = pollutant.concentration as Record<string, Object> || {}
      const value = parseFloat(concentration.value as string) || 0
      
      switch (code) {
        case 'pm2p5':
          airQuality.pm25 = Math.round(value)
          break
        case 'pm10':
          airQuality.pm10 = Math.round(value)
          break
        case 'no2':
          airQuality.no2 = Math.round(value)
          break
        case 'so2':
          airQuality.so2 = Math.round(value)
          break
        case 'o3':
          airQuality.o3 = Math.round(value)
          break
        case 'co':
          airQuality.co = parseFloat(value.toFixed(1))
          break
      }
    })

    return airQuality
  } catch (error) {
    throw new Error(`获取空气质量失败: ${(error as Error).message}`)
  }
}

/**
 * 获取生活指数数据（修正：URL拼接+type参数+容错）
 * @param location 城市ID或经纬度格式：纬度,经度（lat,lon）
 * @returns Promise<LifeIndex>
 */
export async function getLifeIndex(location: string): Promise<LifeIndex> {
  try {
    // 修正：type=0 表示返回所有生活指数，接口路径正确
    const url = `${BASE_URL}/indices/1d?type=0&location=${location}&key=${KEY}`
    const data = await httpRequest(url)

    if (data.code === '200') {
      const lifeIndex = new LifeIndex()
      const indices = (data.daily as Array<Record<string, Object>>) || []

      indices.forEach((item: Record<string, Object>) => {
        const indexItem = new LifeIndexItem()
        indexItem.level = (item.level as string) || ''
        indexItem.description = (item.category as string) || ''
        indexItem.advice = (item.text as string) || ''
        const name = ((item.name as string) || '').toLowerCase()
        const typeCode = (item.type as string) || ''

        switch (typeCode) {
          // 兜底映射：以当前接口 type 码推测
          case '1': lifeIndex.sports = indexItem; break       // 运动
          case '2': lifeIndex.carWash = indexItem; break       // 洗车
          case '3': lifeIndex.clothes = indexItem; break       // 穿衣
          case '4': lifeIndex.fishing = indexItem; break       // 钓鱼（部分文档为4/6）
          case '5': lifeIndex.sunscreen = indexItem; break     // 紫外线/防晒
          case '6': lifeIndex.fishing = indexItem; break       // 兼容钓鱼
          case '8': lifeIndex.coldRisk = indexItem; break      // 感冒
          case '9': lifeIndex.umbrella = indexItem; break      // 雨伞/出行/空气扩散
          case '10': lifeIndex.umbrella = indexItem; break     // 兼容雨伞
        }

        // 名称优先覆盖，避免后端 type 映射调整导致错位
        if (name.includes('穿衣')) {
          lifeIndex.clothes = indexItem
        } else if (name.includes('运动')) {
          lifeIndex.sports = indexItem
        } else if (name.includes('洗车')) {
          lifeIndex.carWash = indexItem
        } else if (name.includes('感冒')) {
          lifeIndex.coldRisk = indexItem
        } else if (name.includes('钓')) {
          lifeIndex.fishing = indexItem
        } else if (name.includes('紫外') || name.includes('防晒')) {
          lifeIndex.sunscreen = indexItem
        } else if (name.includes('伞') || name.includes('雨') || name.includes('出行')) {
          lifeIndex.umbrella = indexItem
        }
      })

      return lifeIndex
    } else {
      throw new Error(`API Error: ${data.code} - ${data.msg || '无描述'}`)
    }
  } catch (error) {
    throw new Error(`获取生活指数失败: ${(error as Error).message}`)
  }
}

/**
 * 获取极端天气预警数据（修正：URL拼接+容错）
 * @param location 城市ID或经纬度格式：纬度,经度（lat,lon）
 * @returns Promise<ExtremeWeatherWarning[]>
 */
export async function getExtremeWeatherWarnings(location: string): Promise<ExtremeWeatherWarning[]> {
  try {
    const url = `${BASE_URL}/warning/now?location=${location}&key=${KEY}`
    const data = await httpRequest(url)

    if (data.code === '200') {
      const warnings: ExtremeWeatherWarning[] = []
      const warningData = (data.warning as Array<Record<string, Object>>) || []

      for (let i = 0; i < warningData.length; i++) {
        const item = warningData[i] || {}
        const warning = new ExtremeWeatherWarning()
        warning.id = (item.id as string) || ''
        warning.sender = (item.sender as string) || ''
        warning.pubTime = (item.pubTime as string) || ''
        warning.title = (item.title as string) || ''
        warning.level = (item.level as string) || ''
        warning.type = (item.type as string) || ''
        warning.description = (item.text as string) || ''
        warning.startTime = (item.startTime as string) || ''
        warning.endTime = (item.endTime as string) || ''
        warnings.push(warning)
      }

      return warnings
    } else {
      throw new Error(`API Error: ${data.code} - ${data.msg || '无描述'}`)
    }
  } catch (error) {
    throw new Error(`获取极端天气预警失败: ${(error as Error).message}`)
  }
}

/**
 * 城市搜索（核心修正：地理编码接口路径+域名）
 * @param cityName 城市名称
 * @returns Promise<CityInfo[]>
 */
export async function searchCity(cityName: string): Promise<CityInfo[]> {
  try {
    // 修正：地理编码接口也使用api.qweather.com域名
    const url = `${GEO_URL}/geo/v2/city/lookup?location=${encodeURIComponent(cityName)}&key=${KEY}`
    const data = await httpRequest(url)

    if (data.code === '200') {
      const cities: CityInfo[] = []
      const locationData = (data.location as Array<Record<string, Object>>) || []

      for (let i = 0; i < locationData.length; i++) {
        const item = locationData[i] || {}
        const city = new CityInfo()
        city.id = (item.id as string) || ''
        city.name = (item.name as string) || ''
        city.latitude = parseFloat(item.lat as string) || 0
        city.longitude = parseFloat(item.lon as string) || 0
        cities.push(city)
      }

      return cities
    } else {
      throw new Error(`API Error: ${data.code} - ${data.msg || '无描述'}`)
    }
  } catch (error) {
    throw new Error(`搜索城市失败: ${(error as Error).message}`)
  }
}