using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.TONGDAT_DTO
{
    public class DoiTuongDTO
    {

        [JsonProperty("maTuCach")]
        public string MaTuCach { get; set; }

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

        [JsonProperty("sothongbao")]
        public string Sothongbao { get; set; }

        [JsonProperty("ngaythongbao")]
        public DateTime? Ngaythongbao { get; set; }

        [JsonProperty("mappingID")]
        public decimal? MappingID { get; set; }

        [JsonProperty("mathongbao")]
        public string Mathongbao { get; set; }
    }
}