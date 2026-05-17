using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.TONGDAT_DTO
{
    public class TongDatDTO
    {

        [JsonProperty("id")]
        public decimal ID { get; set; }

        [JsonProperty("loaiAnId")]
        public decimal? LoaiAnID { get; set; }

        [JsonProperty("tongDatId")]
        public decimal? TongDatId { get; set; }

        [JsonProperty("donId")]
        public decimal? DonId { get; set; }

        [JsonProperty("bieuMauId")]
        public decimal? BieuMauId { get; set; }

        [JsonProperty("bieuMau")]
        public string BieuMau { get; set; }

        [JsonProperty("maBieuMau")]
        public string MaBieuMau { get; set; }

        [JsonProperty("toaAnId")]
        public decimal? ToaAnId { get; set; }

        [JsonProperty("isTdVks")]
        public decimal? IsTdVks { get; set; }

        [JsonProperty("nguoiTao")]
        public string NguoiTao { get; set; }

        [JsonProperty("ngayTao")]
        public DateTime? NgayTao { get; set; }

        [JsonProperty("nguoiSua")]
        public string NguoiSua { get; set; }

        [JsonProperty("nguoiTaoId")]
        public decimal? NguoiTaoId { get; set; }

        [JsonProperty("mavuviec")]
        public string Mavuviec { get; set; }

        [JsonProperty("magiaidoan")]
        public decimal? Magiaidoan { get; set; }

        [JsonProperty("tenvuviec")]
        public string Tenvuviec { get; set; }

        [JsonProperty("sothongbao")]
        public string Sothongbao { get; set; }

        [JsonProperty("ngaythongbao")]
        public DateTime? Ngaythongbao { get; set; }

        [JsonProperty("nguoiky")]
        public decimal? Nguoiky { get; set; }

        [JsonProperty("loaiAn")]
        public string loaiAn { get; set; }

        [JsonProperty("nguyenDon")]
        public string nguyenDon { get; set; }

        [JsonProperty("biDon")]
        public string biDon { get; set; }

        [JsonProperty("biCao")]
        public string biCao { get; set; }

        [JsonProperty("qhpl")]
        public string qhpl { get; set; }

        [JsonProperty("toiDanhId")]
        public decimal? toiDanhId { get; set; }

        //[JsonProperty("mapID")]
        //public decimal? mapID { get; set; }

        //[JsonProperty("mapTable")]
        //public string mapTable { get; set; }

        //[JsonProperty("mathongbao")]
        //public string mathongbao { get; set; }
        
        [JsonProperty("doiTuong")]
        public List<DoiTuongDTO> DoiTuong { get; set; }
    }
}