using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.GSTP.Models
{
    /* Danh sách các nguyên đơn và bị đơn(List<object>) */
    public class NGUOI_THAM_GIA_AK
    {
        /* Tên đương sự */
        public string TENDUONGSU { get; set; }
        /* Guid của đương sự */
        public byte[] Guid { get; set; }
        /* Số CMND */
        public string CMND { get; set; }
        /* Ngày sinh */
        public string NGAYSINH { get; set; }
        /* Năm sinh */
        public string NAMSINH { get; set; }
        /* Giới tính (1-nam; 0- nữ) */
        public int GIOITINH { get; set; }
        /* Mã quốc tịch */
        public string QUOCTICH { get; set; }
        /* Mã tỉnh */
        public string MA_TINH { get; set; }
        /* Mã huyện */
        public string MA_HUYEN { get; set; }
        /* Địa chỉ chi tiết nơi cư trú */
        public string DIACHICHITIET { get; set; }
        /* Loại đương sự "CANHAN-COQUAN-TOCHUC" */
        public string LOAIDUONGSU { get; set; }
        /* Người đại diện */
        public string NGUOIDAIDIEN { get; set; }
        /* Mã tư cách tố tụng */
        public string TUCACHTOTUNG { get; set; }
        /* Mã quan hệ pháp luật */
        public string QHPLMA { get; set; }
    }
}