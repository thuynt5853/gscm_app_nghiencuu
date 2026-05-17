namespace BL.GSTP.BANGSETGET.BANGIAOAN
{
    public class BANGIAOAN_INPUT
    {
        /// <summary>
        /// ID
        /// </summary>
        public string Id { get; set; }

        /// <summary>
        /// ID Toà giao
        /// </summary>
        public string ToaAnGiaoId { get; set; }

        /// <summary>
        /// Tên toà giao
        /// </summary>
        public string ToaAnGiaoTen { get; set; }

        /// <summary>
        /// ID Toà Nhận
        /// </summary>
        public string ToaAnNhanId { get; set; }

        /// <summary>
        /// Tên toà nhận
        /// </summary>
        public string ToaAnNhanTen { get; set; }

        /// <summary>
        /// ID Vụ việc
        /// </summary>
        public string VuViecId { get; set; }

        /// <summary>
        /// Loại Vụ việc
        /// </summary>
        public string VuViecLoai { get; set; }

        /// <summary>
        /// Mã vụ việc
        /// </summary>
        public string VuViecMa { get; set; }

        /// <summary>
        /// Tên vụ việc
        /// </summary>
        public string VuViecTen { get; set; }

        /// <summary>
        /// Id người giao
        /// </summary>
        public string NguoiGiaoId { get; set; }

        /// <summary>
        /// Tên người giao
        /// </summary>
        public string NguoiGiaoTen { get; set; }

        /// <summary>
        /// Id người nhận
        /// </summary>
        public string NguoiNhanId { get; set; }

        /// <summary>
        /// Tên người nhận
        /// </summary>
        public string NguoiNhanTen { get; set; }

        /// <summary>
        /// Mã lý do
        /// </summary>
        public string LyDoMa { get; set; }

        /// <summary>
        /// Tên lý do
        /// </summary>
        public string LyDoTen { get; set; }

        /// <summary>
        /// Ngày giao
        /// </summary>
        public string NgayGiao { get; set; }//dd/MM/yyyy

        /// <summary>
        /// Ngày nhận
        /// </summary>
        public string NgayNhan { get; set; }//dd/MM/yyyy

        /// <summary>
        /// Quyết định chuyển
        /// </summary>
        public bool? IsQuyetDinhChuyen { get; set; }

        /// <summary>
        /// Số quyết định
        /// </summary>
        public string SoQuyetDinh { get; set; }

        /// <summary>
        /// Ngày quyết định
        /// </summary>
        public string NgayQuyetDinh { get; set; }//dd/MM/yyyy

        /// <summary>
        /// Người ký
        /// </summary>
        public string NguoiKy { get; set; }

        /// <summary>
        /// Trạng thái
        /// </summary>
        public string TrangThai { get; set; }

        /// <summary>
        /// Ghi chú
        /// </summary>
        public string GhiChu { get; set; }
    }
}