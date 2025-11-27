/**
 * 云犀天气 - 网络工具类
 *//*


import { API_BASE_URL, API_KEY } from '../constants/Constants';
import { resourceManager } from '@ohos.resourceManager';

export class NetworkUtils {
  // 默认超时时间（毫秒）
  private static readonly DEFAULT_TIMEOUT = 15000;
  // 最大重试次数
  private static readonly MAX_RETRY_COUNT = 2;

  */
/**
   * GET 请求
   * @param endpoint API 端点
   * @param params 查询参数
   * @param retryCount 重试次数
   * @returns Promise<any>
   *//*

  static async get(endpoint: string, params: Record<string, string> = {}, retryCount: number = 0): Promise<any> {
    try {
      // 构建完整URL
      const url = this.buildUrl(endpoint, params);

      // 创建请求
      const httpRequest = new XMLHttpRequest();

      return new Promise((resolve, reject) => {
        httpRequest.onreadystatechange = () => {
          if (httpRequest.readyState === XMLHttpRequest.DONE) {
            if (httpRequest.status >= 200 && httpRequest.status < 300) {
              try {
                const response = JSON.parse(httpRequest.responseText);
                // 检查API返回状态
                if (response.code === '200' || response.code === 200) {
                  resolve(response);
                } else {
                  reject(this.handleError(response, endpoint));
                }
              } catch (error) {
                reject(new Error($r('app.string.network_error').toString()));
              }
            } else if (httpRequest.status >= 400) {
              reject(new Error(`${$r('app.string.network_error').toString()}: ${httpRequest.status}`));
            }
          }
        };

        httpRequest.onerror = () => {
          if (retryCount < this.MAX_RETRY_COUNT) {
            // 重试逻辑
            setTimeout(() => {
              this.get(endpoint, params, retryCount + 1)
                .then(resolve)
                .catch(reject);
            }, 1000 * (retryCount + 1)); // 指数退避
          } else {
            reject(new Error($r('app.string.network_error').toString()));
          }
        };

        httpRequest.ontimeout = () => {
          reject(new Error($r('app.string.network_timeout').toString()));
        };

        httpRequest.open('GET', url, true);
        httpRequest.timeout = this.DEFAULT_TIMEOUT;
        httpRequest.setRequestHeader('Content-Type', 'application/json');
        httpRequest.send();
      });
    } catch (error) {
      return Promise.reject(error);
    }
  }

  */
/**
   * 构建完整URL
   * @param endpoint API端点
   * @param params 查询参数
   * @returns 完整URL
   *//*

  private static buildUrl(endpoint: string, params: Record<string, string> = {}): string {
    // 添加API密钥
    params.key = API_KEY;

    // 构建查询字符串
    const queryString = Object.keys(params)
      .map(key => `${encodeURIComponent(key)}=${encodeURIComponent(params[key])}`)
      .join('&');

    return `${API_BASE_URL}/${endpoint}?${queryString}`;
  }

  */
/**
   * 处理API错误
   * @param errorResponse 错误响应
   * @param endpoint 请求端点
   * @returns 处理后的错误
   *//*

  private static handleError(errorResponse: any, endpoint: string): Error {
    let errorMessage = $r('app.string.network_error').toString();

    // 根据不同错误码提供具体信息
    if (errorResponse.code) {
      switch (errorResponse.code) {
        case '404':
          errorMessage = $r('app.string.city_not_found').toString();
          break;
        case '401':
          errorMessage = $r('app.string.api_key_invalid').toString();
          break;
        case '500':
          errorMessage = $r('app.string.server_error').toString();
          break;
        default:
          errorMessage = `${$r('app.string.api_error').toString()}: ${errorResponse.code}`;
      }
    }

    return new Error(errorMessage);
  }

  */
/**
   * 检查网络连接状态
   * @returns 是否有网络连接
   *//*

  static async isNetworkAvailable(): Promise<boolean> {
    try {
      // 尝试一个简单的网络请求
      await this.get('weather/now', {
        location: '101010100' // 北京的和风天气ID
      });
      return true;
    } catch (error) {
      return false;
    }
  }

  */
/**
   * 获取资源字符串（备用方法，当$r()在某些上下文中不可用时）
   * @param key 资源键
   * @returns 资源字符串
   *//*

  private static async getResourceString(key: string): Promise<string> {
    try {
      const resMgr = await resourceManager.getResourceManager();
      const value = await resMgr.getString($r(`app.string.${key}`).id);
      return value;
    } catch (error) {
      // 默认回退值
      const fallbacks: Record<string, string> = {
        'network_error': '网络请求失败，请检查网络连接',
        'network_timeout': '请求超时，请重试',
        'city_not_found': '未找到该城市，请重试',
        'api_key_invalid': 'API密钥无效',
        'server_error': '服务器错误',
        'api_error': 'API错误'
      };
      return fallbacks[key] || '未知错误';
    }
  }
}*/
