using DAL.GSTP;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using WEB.Service.Models;
using WEB.Service.Models.VanBan;
using Module.Common;
using System.Data;
using WEB.Service.Controllers.Utils;
using BL.GSTP.GDTTT;


namespace WEB.Service.Controllers
{
    public class WS_VanBanDenController : ApiController
    {

        // khai báo danh sách sequence của các bảng
        private const string VT_VANBANDEN_SEQ = "VT_VANBANDEN_SEQ";
        private const string VT_CHUYEN_NHAN_SEQ = "VT_CHUYEN_NHAN_SEQ";
        private const string VT_VANBANDEN_FILE_SEQ = "VT_VANBANDEN_FILE_SEQ";
        private const string DON_GUINHAN_SEQ = "DON_GUINHAN_SEQ";

        private GSTPContext context = new GSTPContext();
        private VT_VANTHU_DEN_BL vanThuDenBL = new VT_VANTHU_DEN_BL();
        private VT_CHUYEN_NHAN_BL chuyenNhanBL = new VT_CHUYEN_NHAN_BL();

        /// <summary>
        /// Hàm kiểm tra token hợp lệ
        /// </summary>
        /// <param name="token">Token kiểm tra</param>
        /// <returns>Trả về true nếu token hợp lệ, false nếu không hợp lệ</returns>
        private bool isAccesable(string token)
        {
            DM_TOKEN_KEY oTokenKey = context.DM_TOKEN_KEY
                .Where(x => x.TOKEN_KEY.ToLower() == token.ToLower())
                .FirstOrDefault<DM_TOKEN_KEY>();
            if (oTokenKey != null)
                return oTokenKey.EXPIRED_TIME >= DataUtils.GetCurrentUnixTimestampMillis(DateTime.Now);
            return false;
        }

        /// <summary>
        /// Hàm thực hiện kiểm tra token 
        /// </summary>
        /// <param name="token">Token cần kiểm tra</param>
        /// <returns>Kết quả kiểm tra token</returns>
        private MessageResult checkToken(string token)
        {
            if (!isAccesable(token))
            {
                MessageResult result = new MessageResult();
                result.Status = "01";
                result.Message = "Token key quá hạn hoặc không tìm thấy trên hệ thống";
                return result;
            }
            return null;
        }

        /// <summary>
        /// Hàm lấy thông tin token từ header
        /// </summary>
        /// <returns>Trả lại giá trị token từ header</returns>
        private string getTokenInHeader()
        {
            var re = Request;
            var headers = re.Headers;
            if (headers.Contains("token"))
            {
                string token = headers.GetValues("token").First();
                return token;
            }
            return null;
        }

        /// <summary>
        /// API Nhận thông tin văn bản đến - Sơ thẩm, phúc thẩm
        /// </summary>
        /// <param name="body">Thông tin văn bản đến</param>
        /// <returns>Kết quả tiếp nhận thông tin văn bản đến</returns>
        [HttpPost]
        [Route("api/Postfulldocinrequest")]
        public MessageResult Postfulldocinrequest([FromBody]VanBanDenDTO body)
        {
            string token = getTokenInHeader();
            MessageResult resultToken = checkToken(token);
            if (resultToken != null)
            {
                return resultToken;
            }

            // TODO: validate body
            // mapping body => entity'
            BL.GSTP.BANGSETGET.VT_VANBANDEN vanBanDen = ToEntity(body);
            if (vanBanDen == null)
            {
                return MessageResult._error("Yêu cầu không hợp lệ");
            }
            // save
            //vanBanDen = context.VT_VANBANDEN.Add(vanBanDen);
            if (vanThuDenBL.VAN_BAN_DEN_INS_UP(vanBanDen))
            {
                vanBanDen.ID = Cls_Comon.ConvertDataTable<BL.GSTP.BANGSETGET.VT_VANBANDEN>(vanThuDenBL.VT_VANBANDEN_BY_ID_VBDH(vanBanDen.ID_VBDH)).FirstOrDefault().ID;
                BL.GSTP.BANGSETGET.VT_CHUYEN_NHAN chuyenNhan = ToEntity(vanBanDen, body);
                //chuyenNhan = context.VT_CHUYEN_NHAN.Add(chuyenNhan);
                if (chuyenNhanBL.VT_CHUYEN_INS(chuyenNhan))
                {
                    chuyenNhan.ID = Cls_Comon.ConvertDataTable<BL.GSTP.BANGSETGET.VT_CHUYEN_NHAN>(chuyenNhanBL.VT_CHUYENNHAN_BY_VANBANDEN_ID(vanBanDen.ID)).FirstOrDefault().ID;
                    //context.SaveChanges();

                    return MessageResult._success(vanBanDen);
                }
                else
                {
                    return MessageResult._error("Lỗi nhận văn bản đến");
                }
            }
            else
            {
                return MessageResult._error("Lỗi nhận văn bản đến");
            }

        }

        /// <summary>
        /// API tiếp nhận thông tin file cho văn bản đến - sơ thẩm, phúc thẩm
        /// </summary>
        /// <param name="vanBanDenId">Id của văn bản đến</param>
        /// <param name="body">Thông tin file của văn bản đến</param>
        /// <returns>Kết quả xử lý</returns>
        [HttpPost]
        [Route("api/PostrecallDocInRequest/{vanBanDenId}")]
        public MessageResult PostrecallDocInRequest([FromUri] long vanBanDenId, [FromBody]List<VanBanDenFileDTO> body)
        {
            string token = getTokenInHeader();
            MessageResult resultToken = checkToken(token);
            if (resultToken != null)
            {
                return resultToken;
            }

            //VT_VANBANDEN vanBanDen = context.VT_VANBANDEN.Where(x => x.ID.Equals(vanBanDenId)).First();
            //if (vanBanDen == null)
            if (chuyenNhanBL.GET_VANTHUDEN(vanBanDenId).Rows.Count == 0)
            {
                return MessageResult._error("Văn bản đến không tồn tại hoặc đã bị xóa");
            }

            foreach (VanBanDenFileDTO element in body)
            {
                VT_VANBANDEN_FILE fileVanBanDen = ToEntity(element, vanBanDenId);
                if (fileVanBanDen == null)
                {
                    return MessageResult._error("Yêu cầu không hợp lệ");
                }
                fileVanBanDen = context.VT_VANBANDEN_FILE.Add(fileVanBanDen);
            }

            // save
            context.SaveChanges();

            return MessageResult._success(body.Count());
        }


        /// <summary>
        /// Hàm convert thông tin văn bản đến từ voffice về Entity trong hệ thống quản lý án
        /// </summary>
        /// <param name="dto">Thông tin văn bản đến gửi từ voffice</param>
        /// <returns>Entity kết quả convert</returns>
        private BL.GSTP.BANGSETGET.VT_VANBANDEN ToEntity(VanBanDenDTO dto)
        {
            if (dto == null)
            {
                return null;
            }
            BL.GSTP.BANGSETGET.VT_VANBANDEN entity = new BL.GSTP.BANGSETGET.VT_VANBANDEN();


            entity.NGUON_DEN = (decimal)dto.ReceiveTypeName.GetValueOrDefault(0);
            entity.SODEN = (decimal)dto.BookNumber.GetValueOrDefault(0);
            entity.NGAY_GIAO_DON = dto.SendDate;
            entity.MABD = dto.ZipCode;
            decimal defaultWeight;
            entity.SOLUONG_GAM = decimal.TryParse(dto.Weight, out defaultWeight) ? defaultWeight : 0;
            entity.NGUOI_GUI_BT = dto.PublishAgencyName;
            decimal intDistrictLettersId = 0;
            if (Decimal.TryParse(dto.DistrictLettersId, out intDistrictLettersId))
            {
                entity.DIACHI_GUI_BT_ID = intDistrictLettersId != 0 ? intDistrictLettersId : (decimal)dto.ProvinceLettersId.GetValueOrDefault(0);
            }
            else
            {
                entity.DIACHI_GUI_BT_ID = dto.ProvinceLettersId.GetValueOrDefault(0);
            }
            entity.DIACHI_GUI_BT = dto.DetailsLetters;
            entity.DIACHI_NDD = dto.DetailsPetition;
            entity.GHICHU = dto.Note;
            entity.NGUOIDUNGDON = dto.Petitioner;

            entity.SOLUONG_DON = dto.NumberOfPetitions.GetValueOrDefault(0);
            entity.BAQD_CHECK_DON = dto.Baqd.GetValueOrDefault(0);
            entity.SO_BAQD_DON = dto.BaqdNumber;
            entity.NGAY_BAQD_DON = dto.BaqdDate;
            entity.TOAAN_BAQD_DON = dto.CourtBaqdId.GetValueOrDefault(0);
            entity.CAP_XX_DON = dto.trialLevel.GetValueOrDefault(0); //
            entity.LOAI_AN_DON = dto.TypeOfSentence.GetValueOrDefault(0);
            entity.SO_CV = dto.DocumentCode; //
            entity.NGAY_CV = dto.PublishDate;
            entity.DONVICHUYEN_CV = dto.officeName;
            entity.NOIDUNG_VB = dto.AbstractField;
            entity.NOIDUNG_CV = dto.AbstractField;
            entity.NGAY_VB = dto.PublishDate;
            entity.DOMAT_ID = dto.SecurityId;
            entity.DO_KHAN_ID = dto.PriorityId;
            entity.NGUOI_TAO = dto.UserCreateName;
            entity.NGUOI_SUA = dto.ModifiedName;
			entity.CANBONHAN_ID = dto.UserCreateId.GetValueOrDefault(0);
			// bo xung thong tin hs khang nghi
			entity.DONVICHUYEN_HS = dto.ProtesterId.GetValueOrDefault(0);
            entity.SO_HS = dto.DocumentCode;
            entity.NGAY_HS = dto.PublishDate;
            entity.GHICHU_HS = dto.AbstractField;
            entity.NGAY_TAO = dto.CreateTime.GetValueOrDefault(DateTime.Now);
            entity.NGAY_DEN = dto.CreateTime.GetValueOrDefault(DateTime.Now);
            entity.NGAY_BT = dto.DatePostMark.GetValueOrDefault(DateTime.Now);
            entity.NOI_NHAN = (decimal)dto.ReceiveDeptId.GetValueOrDefault(0);
            decimal intDistrictPetitionId = 0;
            if (Decimal.TryParse(dto.DistrictPetitionId, out intDistrictPetitionId))
            {
                entity.DIACHI_NDD_ID = intDistrictPetitionId != 0 ? intDistrictPetitionId : (decimal)dto.ProvincePetitionId.GetValueOrDefault(0);
            }
            else
            {
                entity.DIACHI_NDD_ID = dto.ProvincePetitionId.GetValueOrDefault(0);
            }
            entity.LOAI_GDTTTT = dto.ProponeName.GetValueOrDefault(0);


            //entity.NGUOI_NHAN = (decimal) dto.ReceiveUserId.GetValueOrDefault(0);
            entity.DVXULY_ID_DON = dto.ReceiveGroupId.GetValueOrDefault(0);
            entity.LOAI_VB = (decimal)dto.DocumentTypeId.GetValueOrDefault(0);
            entity.ID_VBDH = dto.documentReceiveId.GetValueOrDefault(0);

            // TODO : hard_code
            entity.TOAANID = dto.SendGroupId.GetValueOrDefault(0);
            //entity.NGAY_BT = DateTime.Now;
            // an hinh su
            if (dto.TypeOfSentence != null && dto.TypeOfSentence == 1L)
            {
                entity.QHPL_HS_DON = dto.criminalId.GetValueOrDefault(0);
                entity.BIDON_DON = dto.Defendant;
            }
            else
            {
                entity.NGUYENDON_DON = dto.Plaintiff;
                entity.BIDON_DON = dto.Defendant;
                entity.QHPL_DS_DON = dto.regalRelation;
            }
            return entity;
        }

        /// <summary>
        /// Hàm tạo thông tin VT_CHUYENNHAN từ VT_VANBANDEN
        /// </summary>
        /// <param name="vanBanDen">Dữ liệu bảng VT_VANBANDEN</param>
        /// <param name="vanBanDenDTO">Dữ liệu VanBanDenDTO</param>
        /// <returns>Dữ liệu VT_CHUYENNHAN</returns>
        private BL.GSTP.BANGSETGET.VT_CHUYEN_NHAN ToEntity(BL.GSTP.BANGSETGET.VT_VANBANDEN vanBanDen, VanBanDenDTO vanBanDenDTO)
        {
            BL.GSTP.BANGSETGET.VT_CHUYEN_NHAN chuyenNhan = new BL.GSTP.BANGSETGET.VT_CHUYEN_NHAN();
            chuyenNhan.VANBANDEN_ID = vanBanDen.ID;
			chuyenNhan.DONVI_CHUYEN_ID = vanBanDenDTO.transferDeptId;
			chuyenNhan.CANBO_CHUYEN_ID = vanBanDen.CANBONHAN_ID;
            chuyenNhan.NGUOI_NHAN = vanBanDen.NGUOI_NHAN;
            chuyenNhan.NGAY_CHUYEN = vanBanDenDTO.qlaSendDate != null ? vanBanDenDTO.qlaSendDate : vanBanDen.NGAY_DEN;
            return chuyenNhan;
        }

        /// <summary>
        /// Hàm convert dữ liệu file gửi từ voffice
        /// </summary>
        /// <param name="dto">Thông tin file gửi từ voffice</param>
        /// <param name="vanBanDenId">Id của văn bản đến</param>
        /// <returns>Dữ liệu sau khi convert về entity của hệ thống quản lý án</returns>
        private VT_VANBANDEN_FILE ToEntity(VanBanDenFileDTO dto, decimal vanBanDenId)
        {
            if (dto == null)
                return null;
            VT_VANBANDEN_FILE entity = new VT_VANBANDEN_FILE();
            entity.VBDEN_ID = vanBanDenId;
            entity.TENFILE = dto.AttachmentName;
            entity.KIEUFILE = dto.ContentType;
            entity.NGAYTAO = dto.CreateDate;
            entity.NGUOITAO = dto.CreateUser;

            // decode base 64
            byte[] file = Convert.FromBase64String(dto.ContentTransferEncoded);
            entity.NOIDUNG = file;
            return entity;
        }

        /// <summary>
        /// API thu hồi văn bản đến - giám đốc thẩm
        /// </summary>
        /// <param name="body">Thông tin thu hồi văn bản</param>
        /// <returns>Kết quả thu hồi văn bản</returns>
        [HttpPost]
        [Route("api/thu-hoi")]
        public MessageResult reAllocateDocIn([FromBody]VanBanDenThuHoiDTO body)
        {
            string token = getTokenInHeader();
            MessageResult resultToken = checkToken(token);
            if (resultToken != null)
            {
                return resultToken;
            }
            DON_GUINHAN dON_GUINHAN = context.DON_GUINHAN.Where(x => x.ID_VBDH == body.DocumentId && x.TRANGTHAI != 5).FirstOrDefault();
            // truong hop duoc phep thu hoi
            if (dON_GUINHAN != null && (dON_GUINHAN.TRANGTHAI == 1 || dON_GUINHAN.TRANGTHAI == null))
            {
                dON_GUINHAN.TRANGTHAI = 5;
                context.SaveChanges();
                return MessageResult._success(dON_GUINHAN);
            }
            else
            {
                return MessageResult._error("Văn bản không được phép thu hồi");
            }

        }

        /// <summary>
        /// API thu hồi văn bản đến - sơ thẩm, phúc thẩm
        /// </summary>
        /// <param name="body">Thông tin thu hồi văn bản</param>
        /// <returns>Kết quả thu hồi văn bản</returns>
        [HttpPost]
        [Route("api/thu-hoi-vb")]
        public MessageResult reAllocateDocInVb([FromBody]VanBanDenThuHoiDTO body)
        {
            string token = getTokenInHeader();
            MessageResult resultToken = checkToken(token);
            if (resultToken != null)
            {
                return resultToken;
            }
            //VT_VANBANDEN vT_VANBANDEN = context.VT_VANBANDEN.Where(x => x.ID_VBDH == body.DocumentId).FirstOrDefault();
            if (body.DocumentId == null)
            {
                return MessageResult._error("Lỗi truyền thiếu dữ liệu");
            }
            BL.GSTP.BANGSETGET.VT_VANBANDEN vT_VANBANDEN = Cls_Comon.ConvertDataTable<BL.GSTP.BANGSETGET.VT_VANBANDEN>(vanThuDenBL.VT_VANBANDEN_BY_ID_VBDH((decimal)body.DocumentId)).FirstOrDefault();
            // truong hop duoc phep thu hoi
            if (vT_VANBANDEN != null)
            {
                //VT_CHUYEN_NHAN vT_CHUYEN_NHAN = context.VT_CHUYEN_NHAN.Where(x => x.VANBANDEN_ID == vT_VANBANDEN.ID).FirstOrDefault();
                BL.GSTP.BANGSETGET.VT_CHUYEN_NHAN vT_CHUYEN_NHAN = Cls_Comon.ConvertDataTable<BL.GSTP.BANGSETGET.VT_CHUYEN_NHAN>(chuyenNhanBL.VT_CHUYENNHAN_BY_VANBANDEN_ID(vT_VANBANDEN.ID)).FirstOrDefault();
                if (vT_CHUYEN_NHAN != null && vT_CHUYEN_NHAN.TRANG_THAI_XLY == null)
                {
                    //vT_CHUYEN_NHAN.TRANG_THAI_XLY = 5;
                    //context.SaveChanges();
                    String canBoNhanID = null;
                    chuyenNhanBL.VT_HUY_CHUYEN(vT_VANBANDEN.ID.ToString(), ref canBoNhanID);
                    if (canBoNhanID == null || canBoNhanID == "")
                    {
                        vanThuDenBL.VAN_BAN_DEN_DELETE(vT_VANBANDEN.ID.ToString());
                        return MessageResult._success(vT_VANBANDEN);
                    }
                    else
                    {
                        return MessageResult._error("Văn bản không được phép thu hồi do đã có người nhận");
                    }
                }
                else
                {
                    return MessageResult._error("Văn bản không được phép thu hồi");

                }
            }
            else
            {
                return MessageResult._error("Văn bản không tồn tại trong hệ thống quản lý án");
            }

        }

        /// <summary>
        ///  API tiếp nhận thông tin văn bản đến - giám đốc thẩm
        /// </summary>
        /// <param name="body">Thông tin văn bản đến</param>
        /// <returns>Kết quả tiếp nhận thông tin văn bản đến</returns>
        [HttpPost]
        [Route("api/gui-don")]
        public MessageResult sendDon([FromBody]VanBanDenDonDTO body)
        {
            string token = getTokenInHeader();
            MessageResult resultToken = checkToken(token);
            if (resultToken != null)
            {
                return resultToken;
            }
            // TODO: validate body
            // mapping body => entity'
            DON_GUINHAN dON_GUINHAN = ToEntityDonGuiNhan(body);
            if (dON_GUINHAN == null)
            {
                return MessageResult._error("Yêu cầu không hợp lệ");
            }
            bool success = false;
            using (var transaction = context.Database.BeginTransaction())
            {
                try
                {
                    // DON_GUINHAN
                    dON_GUINHAN = context.DON_GUINHAN.Add(dON_GUINHAN);
                    context.SaveChanges();
                    // DON_GUINHAN_DUONGSU
                    List<DON_GUINHAN_DUONGSU> duongSuList = ToEntityDonGuiNhanDuongSu(dON_GUINHAN, body);
                    if (duongSuList != null)
                    {
                        context.DON_GUINHAN_DUONGSU.AddRange(duongSuList);
                    }
                    context.SaveChanges();

                    transaction.Commit();
                    success = true;
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    Console.WriteLine("Error occurred.");
                }
            }

            if (success)
            {
                return MessageResult._success(dON_GUINHAN);
            }
            else
            {
                return MessageResult._error("Lỗi gửi đơn");
            }
        }

        /// <summary>
        /// Hàm convert thông tin DON_GUINHAN và văn bản đến về entity của DON_GUINHAN_DUONGSU
        /// </summary>
        /// <param name="dON_GUINHAN">Dữ liệu bảng DON_GUINHAN</param>
        /// <param name="vanBanDen">Thông tin văn bản đến từ voffice</param>
        /// <returns>Danh sách DON_GUINHAN_DUONGSU</returns>
        private List<DON_GUINHAN_DUONGSU> ToEntityDonGuiNhanDuongSu(DON_GUINHAN dON_GUINHAN, VanBanDenDonDTO vanBanDen)
        {
            if (vanBanDen == null || vanBanDen.documentTypeId == 0) return null;
            List<DON_GUINHAN_DUONGSU> result = new List<DON_GUINHAN_DUONGSU>();
            DON_GUINHAN_DUONGSU duongSu1 = new DON_GUINHAN_DUONGSU();
            DON_GUINHAN_DUONGSU duongSu2 = new DON_GUINHAN_DUONGSU();
            DON_GUINHAN_DUONGSU duongSu3 = new DON_GUINHAN_DUONGSU();
            decimal? masothue1 = getMaSoThue(vanBanDen);
            decimal? masothue2 = getMaSoThueAccused(vanBanDen);
            if (vanBanDen.documentTypeId == 1)
            {
                duongSu1.ID_DON = dON_GUINHAN.ID;
                duongSu1.LOAIDUONGSU = vanBanDen.petitionerType;
                duongSu1.HOTEN = vanBanDen.partiesName;
                duongSu1.TUCACHTOTUNG = "NGUYENDON";
                duongSu1.SOCMND = vanBanDen.idNumber;
                duongSu1.NAMSINH = vanBanDen.birthday;
                duongSu1.GIOITINH = vanBanDen.gender;
                duongSu1.TAMTRUTINHID = vanBanDen.tabernacleProvinceId;
                duongSu1.TAMTRUID = vanBanDen.residenceId;
                duongSu1.TAMTRUCHITIET = vanBanDen.residence;
                duongSu1.EMAIL = vanBanDen.email;
                duongSu1.DIENTHOAI = vanBanDen.telephone;
                duongSu1.MASOTHUE = masothue1.ToString();
                duongSu1.NDD_CHUCVU = vanBanDen.position;
                duongSu1.NDD_NGUOIDAIDIEN = vanBanDen.representative;
                duongSu1.NDD_TAMTRUCHITIET = vanBanDen.residence;
                duongSu1.NDD_TAMTRUTINHID = vanBanDen.tabernacleProvinceId;
                duongSu1.NDD_TAMTRUHUYENID = vanBanDen.residenceId;

                result.Add(duongSu1);

                duongSu2.ID_DON = dON_GUINHAN.ID;
                duongSu2.LOAIDUONGSU = vanBanDen.petitionerTypeAccused;
                duongSu2.HOTEN = vanBanDen.partiesNameAccused;
                duongSu2.TUCACHTOTUNG = "BIDON";
                duongSu2.SOCMND = vanBanDen.idNumberAccused;
                duongSu2.NAMSINH = vanBanDen.birthdayAccused;
                duongSu2.GIOITINH = vanBanDen.genderAccused;
                duongSu2.TAMTRUTINHID = vanBanDen.tabernacleProvinceIdAccused;
                duongSu2.TAMTRUID = vanBanDen.residenceIdAccused;
                duongSu2.TAMTRUCHITIET = vanBanDen.residenceAccused;
                duongSu2.MASOTHUE = masothue2.ToString();
                duongSu2.NDD_CHUCVU = vanBanDen.positionAccused;
                duongSu2.NDD_NGUOIDAIDIEN = vanBanDen.representativeAccused;
                duongSu2.NDD_TAMTRUCHITIET = vanBanDen.residenceAccused;
                duongSu2.NDD_TAMTRUTINHID = vanBanDen.tabernacleProvinceIdAccused;
                duongSu2.NDD_TAMTRUHUYENID = vanBanDen.residenceIdAccused;

                result.Add(duongSu2);

            }
            else if (vanBanDen.documentTypeId == 2)
            {
                // nguoi khang cao
                duongSu1.ID_DON = dON_GUINHAN.ID;
                duongSu1.LOAIDUONGSU = vanBanDen.petitionerType;
                duongSu1.HOTEN = vanBanDen.partiesName;
                // get from proceedingsId
                duongSu1.SOCMND = vanBanDen.idNumber;
                duongSu1.NAMSINH = vanBanDen.birthday;
                duongSu1.GIOITINH = vanBanDen.gender;
                duongSu1.TAMTRUTINHID = vanBanDen.tabernacleProvinceId;
                duongSu1.TAMTRUID = vanBanDen.residenceId;
                duongSu1.TAMTRUCHITIET = vanBanDen.residence;
                duongSu1.EMAIL = vanBanDen.email;
                duongSu1.DIENTHOAI = vanBanDen.telephone;
                duongSu1.NGUOIKHANGCAO = 1;
                duongSu1.TUCACHTOTUNG = vanBanDen.proceedingsId;
                duongSu1.MASOTHUE = masothue1.ToString();
                duongSu1.NDD_CHUCVU = vanBanDen.position;
                duongSu1.NDD_NGUOIDAIDIEN = vanBanDen.representative;
                duongSu1.NDD_TAMTRUCHITIET = vanBanDen.residence;
                duongSu1.NDD_TAMTRUTINHID = vanBanDen.tabernacleProvinceId;
                duongSu1.NDD_TAMTRUHUYENID = vanBanDen.residenceId;

                result.Add(duongSu1);

                // nguoi khoi kien
                if (vanBanDen.accused != null)
                {
                    duongSu2.ID_DON = dON_GUINHAN.ID;
                    duongSu2.HOTEN = vanBanDen.accused;
                    // loai an hinh su
                    if (vanBanDen.typeOfSentence != null && vanBanDen.typeOfSentence == 1)
                    {
                        duongSu2.TUCACHTOTUNG = "BICAO";
                    }
                    else
                    {
                        duongSu2.TUCACHTOTUNG = "NGUYENDON";
                    }

                    result.Add(duongSu2);
                }


                // nguoi bi kien
                if (vanBanDen.defendant != null)
                {
                    duongSu3.ID_DON = dON_GUINHAN.ID;
                    duongSu3.HOTEN = vanBanDen.defendant;
                    // loai an hinh su
                    if (vanBanDen.typeOfSentence != null && vanBanDen.typeOfSentence == 1)
                    {
                        duongSu3.TUCACHTOTUNG = "TGTTHS_01";
                    }
                    else
                    {
                        duongSu3.TUCACHTOTUNG = "BIDON";
                    }


                    result.Add(duongSu3);
                }

            }
            else if (vanBanDen.documentTypeId == 3)
            {
                // nguoi dung don
                duongSu1.ID_DON = dON_GUINHAN.ID;
                duongSu1.LOAIDUONGSU = vanBanDen.petitionerType;
                duongSu1.HOTEN = vanBanDen.partiesName;
                duongSu1.SOCMND = vanBanDen.idNumber;
                duongSu1.NAMSINH = vanBanDen.birthday;
                duongSu1.GIOITINH = vanBanDen.gender;
                duongSu1.TAMTRUTINHID = vanBanDen.tabernacleProvinceId;
                duongSu1.TAMTRUID = vanBanDen.residenceId;
                duongSu1.TAMTRUCHITIET = vanBanDen.residence;
                duongSu1.EMAIL = vanBanDen.email;
                duongSu1.DIENTHOAI = vanBanDen.telephone;
                duongSu1.NGUOIKHANGCAO = 2;
                duongSu1.MASOTHUE = masothue1.ToString();
                duongSu1.NDD_CHUCVU = vanBanDen.position;
                duongSu1.NDD_NGUOIDAIDIEN = vanBanDen.representative;
                duongSu1.NDD_TAMTRUCHITIET = vanBanDen.residence;
                duongSu1.NDD_TAMTRUTINHID = vanBanDen.tabernacleProvinceId;
                duongSu1.NDD_TAMTRUHUYENID = vanBanDen.residenceId;

                result.Add(duongSu1);

                // nguoi khoi kien
                if (vanBanDen.accused != null)
                {
                    duongSu2.ID_DON = dON_GUINHAN.ID;
                    duongSu2.HOTEN = vanBanDen.accused;
                    if (vanBanDen.typeOfSentence != null && vanBanDen.typeOfSentence == 1)
                    {
                        duongSu2.TUCACHTOTUNG = "BICAO";
                    }
                    else
                    {
                        duongSu2.TUCACHTOTUNG = "NGUYENDON";
                    }

                    result.Add(duongSu2);
                }


                // nguoi bi kien
                if (vanBanDen.defendant != null)
                {
                    duongSu3.ID_DON = dON_GUINHAN.ID;
                    duongSu3.HOTEN = vanBanDen.defendant;
                    // loai an hinh su
                    if (vanBanDen.typeOfSentence != null && vanBanDen.typeOfSentence == 1)
                    {
                        duongSu3.TUCACHTOTUNG = "TGTTHS_01";
                    }
                    else
                    {
                        duongSu3.TUCACHTOTUNG = "BIDON";
                    }

                    result.Add(duongSu3);
                }
            }
            return result;
        }

        /// <summary>
        /// Hàm lấy thông tin mã số thuế của bị đơn
        /// </summary>
        /// <param name="vanBanDen">Thông tin văn bản đến</param>
        /// <returns>Thông tin mã số thuế</returns>
        private decimal? getMaSoThueAccused(VanBanDenDonDTO vanBanDen)
        {
            try
            {
                return Convert.ToDecimal(vanBanDen.taxCodeAccused);

            }
            catch (Exception e)
            {
                return null;
            }
            return null;
        }

        /// <summary>
        /// Hàm lấy thông tin mã số thuế của nguyên đơn
        /// </summary>
        /// <param name="vanBanDen">Thông tin văn bản đến</param>
        /// <returns>Thông tin mã số thuế</returns>
        private decimal? getMaSoThue(VanBanDenDonDTO vanBanDen)
        {
            try
            {
                return Convert.ToDecimal(vanBanDen.taxCode);

            }
            catch (Exception e)
            {
                return null;
            }
            return null;
        }

        /// <summary>
        /// Hàm convert thông tin văn bản đến về entity của DON_GUINHAN
        /// </summary>
        /// <param name="body">Thông tin văn bản đến từ voffice</param>
        /// <returns>Thông tin bảng DON_GUINHAN</returns>
        private DON_GUINHAN ToEntityDonGuiNhan(VanBanDenDonDTO body)
        {
            if (body == null) return null;
            DON_GUINHAN result = new DON_GUINHAN();
            result.NGUONDEN = Convert.ToDecimal(body.receiveTypeName);
            result.LOAIVANBAN = body.documentTypeId;
            result.SODEN = body.bookNumber;
            result.NGAYDEN = body.createTime;
            result.DCGUI = body.districtLettersId != null && body.districtLettersId != 0 ? body.districtLettersId : body.provinceLettersId;
            result.DCGUI_CHITIET = body.detailsLetters;
            result.DV_NHAN = body.receiveDeptId;
            result.DV_GIAIQUYET = body.receiveGroupId;
            result.DV_CHUYEN = body.sendGroupId;
            result.NGUOINHANID = body.receiveUserId;
            result.NGAYGIAO = body.sendDate;
            result.LOAIAN = body.typeOfSentence;
            if (body.documentTypeId == 2)
            {
                result.SO_BAQD = body.baqdNumber;
                result.NGAY_BAQD = body.baqdDate;
                result.TOIDANHID = body.criminalId;
            }
            else if (body.documentTypeId == 3)
            {
                result.SOTHULY = body.baqdNumber;
                result.NGAYTHULY = body.baqdDate;
                result.TOIDANHID = body.criminalId;
            }
            result.TOAAN_BAQD = body.courBaqdId;
            result.TENVUAN = body.caseName;
            result.CAPXETXU = body.trialLevel;
            result.QHPL = body.regalRalations;
            if (body.documentTypeId == 1)
            {
                result.NOIDUNGKHOIKIEN = body.contentLawsuit;
            }
            else
            {
                result.NOIDUNGKHANGCAO = body.contentLawsuit;
            }
            result.SLDON = body.numberOfPetitions;
            result.GHICHU = body.note;
            result.NGAYCHUYEN = DateTime.Now;
            result.NGUOICHUYEN = body.sendUserId;
            result.NGUOIGUI = body.publishAgencyName;
            result.MABUUDIEN = body.zipCode;
            result.NGAYDAUBUUDIEN = body.datePostMark;
            result.ID_VBDH = body.documentReceiveId;
            result.TRANGTHAI = 1;
            result.TOAAN_ID = body.courtId;
            return result;

        }

        /// <summary>
        /// Hàm convert thông tin nguồn đến từ thông tin văn bản gửi từ Voffice
        /// </summary>
        /// <param name="nguonDenString">Giá trị nguồn đến dạng chuỗi</param>
        /// <returns>Giá trị nguồn đến dạng số</returns>
        private decimal? ToNguonDen(string nguonDenString)
        {
            if (nguonDenString == "Bưu điện")
            {
                return 1;
            }
            else if (nguonDenString == "Tiếp công dân")
            {
                return 2;
            }
            else if (nguonDenString == "Trực tiếp")
            {
                return 3;
            }
            return null;
        }
    }
}