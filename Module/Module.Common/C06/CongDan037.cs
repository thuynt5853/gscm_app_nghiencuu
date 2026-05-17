using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Module.Common.C06
{
    public class CongDan037
    {
        public string SoDinhDanh { get; set; }
        public string SoCMND { get; set; }
        public string SoCCCD { get; set; }

        public HoVaTen HoVaTen { get; set; } = new HoVaTen();

        public string GioiTinh { get; set; }
        public string DanToc { get; set; }
        public string TonGiao { get; set; }
        public string TinhTrangHonNhan { get; set; }
        public string NhomMau { get; set; }
        public string NamSinh { get; set; }     
        public string NgayThangNam { get; set; }
        public DiaChi NoiDangKyKhaiSinh { get; set; } = new DiaChi();
        public string QuocTich { get; set; }
        public DiaChi QueQuan { get; set; } = new DiaChi();
        public DiaChi ThuongTru { get; set; } = new DiaChi();
        public DiaChi NoiOHienTai { get; set; } = new DiaChi();

        public NguoiThan Cha { get; set; } = new NguoiThan();
        public NguoiThan Me { get; set; } = new NguoiThan();
        public NguoiThan VoChong { get; set; } = new NguoiThan();
        public NguoiThan NguoiDaiDien { get; set; } = new NguoiThan();

        public ChuHo ChuHo { get; set; } = new ChuHo();

        public string SoSoHoKhau { get; set; }
    }


    public class HoVaTen
    {
        public string Ho { get; set; }
        public string ChuDem { get; set; }
        public string Ten { get; set; }
    }

    public class DiaChi
    {
        public string MaTinhThanh { get; set; }
        public string MaQuanHuyen { get; set; }
        public string MaPhuongXa { get; set; }
        public string ChiTiet { get; set; }
        public string QuocGia { get; set; }
    }

    public class NguoiThan
    {
        public HoVaTen HoVaTen { get; set; } = new HoVaTen();
        public string QuocTich { get; set; }
        public string SoDinhDanh { get; set; }
        public string SoCMND { get; set; }
    }

    public class ChuHo
    {
        public string QuanHe { get; set; }
        public string SoDinhDanh { get; set; }
        public string SoCMND { get; set; }
        public HoVaTen HoVaTen { get; set; } = new HoVaTen();
    }
}