using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.Service.Models.VanBan
{
    public class DoiTuongDTO
    {

        [JsonProperty("maTuCach")]
        public string MaTuCach { get; set; }

        [JsonProperty("isUTTP")]
        public decimal? IsUTTP { get; set; }

        [JsonProperty("uttp")]
        public decimal? UTTP { get; set; }

        [JsonProperty("phatHanhLaiId")]
        public decimal? PhatHanhLaiId { get; set; }

        [JsonProperty("hinhThucGui")]
        public decimal? HinhThucGui { get; set; }
        [JsonProperty("doiTuongId")]
        public decimal? DoiTuongId { get; set; }

        [JsonProperty("duongSuId")]
        public decimal? DuongSuId { get; set; }

        [JsonProperty("tenDuongSu")]
        public string TenDuongSu { get; set; }

        [JsonProperty("soCMND")]
        public string SoCMND { get; set; }

        [JsonProperty("quocTichId")]
        public decimal? QuocTichId { get; set; }

        [JsonProperty("huyenId")]
        public decimal? HuyenId { get; set; }

        [JsonProperty("diaChiChiTiet")]
        public string DiaChiChiTiet { get; set; }

        [JsonProperty("namSinh")]
        public decimal? NamSinh { get; set; }

        [JsonProperty("sinhSongNuocNgoai")]
        public decimal? SinhSongNuocNgoai { get; set; }

        [JsonProperty("tinhId")]
        public decimal? TinhId { get; set; }

        [JsonProperty("quocGia")]
        public decimal? QuocGia { get; set; }

        [JsonProperty("coQuan")]
        public string CoQuan { get; set; }

        [JsonProperty("noiDung")]
        public string NoiDung { get; set; }

        [JsonProperty("nguoiTao")]
        public string NguoiTao { get; set; }

        [JsonProperty("ngayTao")]
        public DateTime? NgayTao { get; set; }

        [JsonProperty("nguoiSua")]
        public string NguoiSua { get; set; }

    }
}