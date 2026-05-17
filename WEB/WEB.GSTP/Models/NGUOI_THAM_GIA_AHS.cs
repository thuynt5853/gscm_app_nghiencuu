using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.GSTP.Models
{
    /* Danh sách các bị cáo, tội danh, hình phạt (List<object>) */
    public class NGUOI_THAM_GIA_AHS
    {
        /* Tên bị cáo */
        public string TENBICAO { get; set; }
        /* Guid của người tham gia */
        public byte[] Guid { get; set; }
        /* Số CMND */
        public string CMND { get; set; }
        /* Ngày sinh dd-MM-yyyy*/
        public string NGAYSINH { get; set; }
        /* Năm sinh */
        public string NAMSINH { get; private set; }
        /* Giới tính (1-nam; 0- nữ) */
        public int GIOITINH { get; set; }
        /* Mã Quốc tịch */
        public string QUOCTICH { get; set; }
        /* Mã tỉnh */
        public string MA_TINH { get; set; }
        /* Mã huyện*/
        public string MA_HUYEN { get; set; }
        /* Địa chỉ chi tiết nơi cư trú */
        public string DIACHICHITIET { get; set; }
        /*Người đại diện*/
        public string NGUOIDAIDIEN { get; set; }
        /* Tội danh  */
        public TOIDANH VTOIDANH { get; set; }
        /* Là bị cáo đầu vụ? */
        public bool ISDAUVU { get; set; }
        /* Lệnh tạm giam */
        public LENHTAMGIAM VLENHTAMGIAM { get; set; }
    }
}