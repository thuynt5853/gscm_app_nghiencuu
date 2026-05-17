using System;

namespace BL.GSTP.BANGSETGET.BIEUMAU.HOAGIAI
{
    /// <summary>
    /// Hướng dẫn sử dụng mẫu số 01-ĐT:
    ///(1) Ghi tên Tòa án nhân dân cấp tỉnh của tỉnh đó nếu Tòa án nhân dân ra thông báo là Tòa án nhân dân cấp huyện(ví dụ: Tòa án nhân dân ra thông báo là Tòa án nhân dân quận Đống Đa, thành phố Hà Nội thì ghi “TÒA ÁN NHÂN DÂN THÀNH PHỐ HÀ NỘI”; Ghi “TÒA ÁN NHÂN DÂN TỐI CAO” nếu Tòa án nhân dân ra thông báo là Tòa án nhân dân cấp tỉnh.
    ///(2), (6) và(12) Ghi tên Tòa án nhân dân ra thông báo; nếu là Tòa án nhân dân huyện, quận, thị xã, thành phố thuộc tỉnh thì ghi rõ tên Tòa án nhân dân huyện, quận, thị xã, thành phố thuộc tỉnh, thành phố trực thuộc Trung ương nào(ví dụ: TÒA ÁN NHÂN DÂN HUYỆN THƯỜNG TÍN); nếu là Tòa án nhân dân tỉnh, thành phố trực thuộc Trung ương thì ghi Tòa án nhân dân tỉnh(thành phố) đó(ví dụ: TÒA ÁN NHÂN DÂN TỈNH HÀ NAM). 
    ///(3) và(4) Nếu là cá nhân thì ghi họ tên, địa chỉ nơi cư trú và nơi làm việc; nếu là cơ quan, tổ chức thì ghi tên, địa chỉ của cơ quan, tổ chức.Cần lưu ý đối với cá nhân, thì tùy theo độ tuổi mà ghi Ông hoặc Bà, Anh hoặc Chị trước khi ghi họ tên(ví dụ: Kính gửi: Anh Trần Văn B).
    ///(5) Ghi quan hệ tranh chấp mà người khởi kiện đề nghị giải quyết.
    ///(7), (8), (10) và(11) Nếu là cá nhân, thì tùy theo độ tuổi mà ghi Ông hoặc Bà, Anh hoặc Chị như hướng dẫn tại điểm(3) mà không phải ghi họ tên(ví dụ: cho Ông, cho Bà biết); nếu là cơ quan, tổ chức, thì ghi tên của cơ quan, tổ chức đó như hướng dẫn tại điểm(3).
    ///(9) Ghi tên Tòa án nhân dân ra thông báo theo hướng dẫn tại điểm(2). Nếu Tòa án ra thông báo là Tòa án nhân dân cấp huyện thì ghi thêm đoạn sau đây: “hoặc Tòa án cấp huyện khác trên cùng phạm vi địa giới hành chính với Tòa án nhân dân cấp tỉnh để tiến hành đối thoại đối với vụ việc nêu trên.Trường hợp lựa chọn Hòa giải viên trong danh sách Hòa giải viên thuộc Tòa án cấp huyện khác với Tòa án nơi tiến hành đối thoại thì phải có sự đồng ý của Hòa giải viên được lựa chọn và Tòa án nơi Hòa giải viên đó làm việc”.

    /// </summary>
    public partial class r01_DT
    {
        public r01_DT()
        {
            this.TOA_CAP_TREN = "                     ";
            this.TOA_HIEN_TAI = "                     ";
            this.TOA_HIEN_TAI_DIACHI = "                     ";
            this.TOA_HIEN_TAI_MAIL = "                     ";
            this.TOA_HIEN_TAI_FAX = "                     ";
            this.SO_THONG_BAO = "     ";
            this.DIACHI = "              ";
            this.NGAY = "      ";
            this.THANG = "      ";
            this.NAM = "      ";
            this.NGUOI_NHAN = "                           ";
            this.NGUOI_NHAN_DIACHI = "                          ";
            this.NGUOI_NHAN_SDT = "                       ";
            this.NGUOI_NHAN_FAX = "                           ";
            this.NGUOI_NHAN_MAIL = "                           ";
            this.NGUOI_NHAN_XUNGHO = "           ";
            this.TEN_QHPL = "                                               ";
            this.TOA_RA_THONGBAO = "                                  ";
            this.NGUOI_KY = "                  ";
        }
        public String TOA_CAP_TREN { get; set; }
        public String TOA_HIEN_TAI { get; set; }
        public String TOA_HIEN_TAI_DIACHI { get; set; }
        public String TOA_HIEN_TAI_MAIL { get; set; }
        public String TOA_HIEN_TAI_FAX { get; set; }
        public String SO_THONG_BAO { get; set; }
        public String DIACHI { get; set; }
        public String NGAY { get; set; }
        public String THANG { get; set; }
        public String NAM { get; set; }
        public String NGUOI_NHAN { get; set; }
        public String NGUOI_NHAN_DIACHI { get; set; }
        public String NGUOI_NHAN_SDT { get; set; }
        public String NGUOI_NHAN_FAX { get; set; }
        public String NGUOI_NHAN_MAIL { get; set; }
        public String NGUOI_NHAN_XUNGHO { get; set; }
        public String TEN_QHPL { get; set; }
        public String TOA_RA_THONGBAO { get; set; }
        public String NGUOI_KY { get; set; }
    }
}