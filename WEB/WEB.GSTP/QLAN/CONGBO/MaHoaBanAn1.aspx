<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MaHoaBanAn1.aspx.cs" Inherits="WEB.GSTP.QLAN.MaHoaBanAn1" Async="true" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%--<%@ Register Assembly="DevExpress.Web.v18.2, Version=18.2.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>--%>
<%@ Import Namespace="WEB.GSTP.QLAN" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" style="height: 100%">
<head runat="server">
    <title>Mã hóa bản án chi tiết</title>
    <link href="../../UI/js/src_duallistbox/bootstrap.min.css" rel="stylesheet" />

    <link href="../../UI/css/style.css" rel="stylesheet" />
    <link href="../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../UI/css/chosen.css" rel="stylesheet" />

    <link href="../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../UI/js/jquery-ui.min.js"></script>
    <script src="../../UI/js/Common.js"></script>

    <script src="../../UI/js/chosen.jquery.js"></script>

    <style>
        body {
            margin-left: 1%;
            min-width: 0px;
            padding-top: 5px;
        }

        .form_tt {
            padding-top: 10px;
            margin: 0 auto;
            /*width: 760px;*/
            position: relative;
        }

        .boder {
            float: left;
            width: 96%;
            padding: 10px 1.5%;
        }

        .t-w-100 {
            width: 100%;
            max-width: 100%;
            min-width: 100%;
            resize: vertical;
        }

        .wrapper {
            height: 100vh;
            background: black;
        }

        .file {
            display: none;
        }

        .d-icon {
            height: 16px;
            width: 16px;
            display: block;
            text-align: center;
            align-items: center;
            background-color: white;
        }

        .d-none {
            display: none;
        }

        .d-icon-upload {
            background: url('../../UI/img/upload-icon.svg');
            background-size: 16px 16px;
            color: white;
        }

        .dropbtn {
            cursor: pointer;
        }

            .dropbtn:hover, .dropbtn:focus {
                background-color: #2980B9;
            }

        .dropdown {
            position: relative;
            display: inline-block;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #f1f1f1;
            min-width: 100px;
            overflow: auto;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 1;
        }

            .dropdown-content a, s {
                color: black;
                padding: 12px 16px;
                text-decoration: none;
                display: block;
            }

        .dropdown a:hover {
            background-color: #ddd;
        }

        .show {
            display: block;
        }

        [type="radio"]:checked {
            font-weight: bold !important;
        }

            [type="radio"]:checked + label:after,
            [type="radio"]:not(:checked) + label:after {
                top: 3px !important;
                left: 3px !important;
            }

        .d-file-upload div input {
            border: solid 1px #cccccc;
            border-radius: 4px;
            height: 20px !important;
            font-size: 12px;
            font-family: Arial, Helvetica, sans-serif;
            color: #044271;
            padding: 2px 3px;
            text-indent: 3px;
        }

        h5 {
            display: block;
            font-size: 0.83em;
            margin-block-start: 1.67em;
            margin-block-end: 1.67em;
            margin-inline-start: 0px;
            margin-inline-end: 0px;
            font-weight: bold;
        }

        * {
            margin: 0px;
            padding: 0px;
            font-size: 12px;
            font-family: Arial;
        }

        .tleboxchung {
            margin-top: -5px;
        }

        .boder {
            width: 100%;
        }

        hr {
            margin: 3px;
        }

        .buttoninput {
            min-width: 50px;
        }

        .d-col-1 {
            width: calc(100% / 12 ) !important;
        }
    </style>
</head>
<body style="width: auto; height: auto; min-height: 500px; min-width: 850px" class="h-100">
    <form id="form1" runat="server" enctype="multipart/form-data" class="h-100">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:TextBox ID="txtTepID" runat="server" Visible="false" />
        <div class="h-100 w-100 p-2 row">
            <div class="col-6 h-100">
                <div class="h-50 pt-2 pb-2">
                    <h5 class="tleboxchung">Tệp gốc</h5>
                    <div class="m-0 boder h-100 overflow-auto">
                        <table class="table1 w-100">
                            <tr>
                                <td>Tên tệp:</td>
                                <td>
                                    <asp:TextBox ID="txtTenTepGoc" CssClass="user d-validator-required" Enabled="false" runat="server" Width="242px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <asp:Panel ID="pnZonekythuongTepGoc" runat="server">
                                    <td>Tệp đính kèm</td>
                                    <td>
                                        <asp:HiddenField ID="hddFilePathTepGoc" runat="server" Value="" />
                                        <div id="zonekythuongTepGoc" style="width: 80%;">
                                            <cc1:AsyncFileUpload ID="AsyncFileUpLoadTepGoc" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                                ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" CssClass="user d-file-upload" />
                                            <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                                        </div>
                                    </td>
                                </asp:Panel>
                            </tr>
                            <tr>
                                <td colspan="100" style="padding: 0px">
                                    <asp:Panel runat="server" ID="pnThongTinTepGoc" Visible="True">
                                        <table class="w-100 h-100">
                                            <tr>
                                                <td class="col-2">Người tạo: 
                                                </td>
                                                <td class="col-4">
                                                    <asp:TextBox runat="server" ID="lblNguoiTaoTepGoc" CssClass="user" Enabled="false"></asp:TextBox>
                                                </td>
                                                <td class="col-2">Ngày tạo:
                                                </td>
                                                <td class="col-4">
                                                    <asp:TextBox runat="server" ID="lblNgayTaoTepGoc" CssClass="user" Enabled="false"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="col-2">Người sửa: 
                                                </td>
                                                <td class="col-4">
                                                    <asp:TextBox runat="server" ID="lblNguoiSuaTepGoc" CssClass="user" Enabled="false"></asp:TextBox>
                                                </td>
                                                <td class="col-2">Ngày sửa: 
                                                </td>
                                                <td class="col-4">
                                                    <asp:TextBox runat="server" ID="lblNgaySuaTepGoc" CssClass="user" Enabled="false"></asp:TextBox>
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                </td>
                            </tr>

                            <tr>
                                <td colspan="4">
                                    <div>
                                        <asp:Label runat="server" ID="lblThongbaoTepGoc" ForeColor="Red" CssClass="d-thongbao"></asp:Label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <hr />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <div class="w-100 row m-0 p-0">
                                        <asp:Button ID="btnLuuTepGoc" runat="server" CssClass="col m-0 p-0 mr-1 mt-1 btn buttoninput" Text="Lưu" OnClick="btnLuu_Click" />
                                        <asp:Button ID="btnXemTepGoc" runat="server" CssClass="col m-0 p-0 mr-1 mt-1 btn buttoninput" Text="Xem" />
                                        <asp:Button ID="btnSuaTepGoc" runat="server" CssClass="col m-0 p-0 mr-1 mt-1 btn buttoninput" Text="Sửa" OnClick="btnSua_Click" />
                                        <asp:Button ID="btnXoaTepGoc" runat="server" CssClass="col m-0 p-0 mr-1 mt-1 btn buttoninput" Text="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa tệp này? ');" OnClick="btnXoa_Click" />
                                        <asp:Button ID="btnTaiVeTepGoc" runat="server" CssClass="col m-0 p-0 mr-1 mt-1 btn buttoninput" Text="Tải về" OnClick="btnTaiVe_Click" />
                                        <asp:Button ID="btnMaHoaTepGoc" runat="server" CssClass="col m-0 p-0 mr-1 mt-1 btn buttoninput" Text="Mã hóa" OnClick="btnMaHoa_Click" />
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="h-50 pt-2 pb-2">
                    <h5 class="tleboxchung">Tệp đã phát hành</h5>
                    <div class="m-0 boder h-100 overflow-auto">
                        <table class="table1 w-100">
                            <tr>
                                <td>Tên tệp:</td>
                                <td>
                                    <asp:TextBox ID="txtTenTepDaPhatHanh" CssClass="user d-validator-required" Enabled="false" runat="server" Width="242px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <asp:Panel ID="pnZonekythuongTepDaPhatHanh" runat="server">
                                    <td>Tệp đính kèm</td>
                                    <td>
                                        <asp:HiddenField ID="hddFilePathTepDaPhatHanh" runat="server" Value="" />
                                        <div id="zonekythuongTepDaPhatHanh" style="width: 80%;">
                                            <cc1:AsyncFileUpload ID="AsyncFileUpLoadTepDaPhatHanh" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                                ErrorBackColor="Red" ThrobberID="Throbber2" UploadingBackColor="#66CCFF" CssClass="user d-file-upload" />
                                            <asp:Image ID="Throbber2" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                                        </div>
                                    </td>
                                </asp:Panel>
                            </tr>
                            <tr>
                                <td colspan="100" style="padding: 0px">
                                    <asp:Panel runat="server" ID="pnThongTinTepDaPhatHanh" Visible="True">
                                        <table class="w-100 h-100">
                                            <tr>
                                                <td class="col-2">Người tạo: 
                                                </td>
                                                <td class="col-4">
                                                    <asp:TextBox runat="server" ID="lblNguoiTaoTepDaPhatHanh" CssClass="user" Enabled="false"></asp:TextBox>
                                                </td>
                                                <td class="col-2">Ngày tạo:
                                                </td>
                                                <td class="col-4">
                                                    <asp:TextBox runat="server" ID="lblNgayTaoTepDaPhatHanh" CssClass="user" Enabled="false"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="col-2">Người sửa: 
                                                </td>
                                                <td class="col-4">
                                                    <asp:TextBox runat="server" ID="lblNguoiSuaTepDaPhatHanh" CssClass="user" Enabled="false"></asp:TextBox>
                                                </td>
                                                <td class="col-2">Ngày sửa: 
                                                </td>
                                                <td class="col-4">
                                                    <asp:TextBox runat="server" ID="lblNgaySuaTepDaPhatHanh" CssClass="user" Enabled="false"></asp:TextBox>
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                </td>
                            </tr>

                            <tr>
                                <td colspan="4">
                                    <div>
                                        <asp:Label runat="server" ID="lblThongbaoTepDaPhatHanh" ForeColor="Red" CssClass="d-thongbao"></asp:Label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <hr />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <div class="w-100 row m-0 p-0">
                                        <asp:Button ID="btnLuuTepDaPhatHanh" runat="server" CssClass="col m-0 p-0 mr-1 mt-1 btn buttoninput" Text="Lưu" OnClick="btnLuu_Click" />
                                        <asp:Button ID="btnXemTepDaPhatHanh" runat="server" CssClass="col m-0 p-0 mr-1 mt-1 btn buttoninput" Text="Xem" />
                                        <asp:Button ID="btnSuaTepDaPhatHanh" runat="server" CssClass="col m-0 p-0 mr-1 mt-1 btn buttoninput" Text="Sửa" OnClick="btnSua_Click" />
                                        <asp:Button ID="btnXoaTepDaPhatHanh" runat="server" CssClass="col m-0 p-0 mr-1 mt-1 btn buttoninput" Text="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa tệp này? ');" OnClick="btnXoa_Click" />
                                        <asp:Button ID="btnTaiVeTepDaPhatHanh" runat="server" CssClass="col m-0 p-0 mr-1 mt-1 btn buttoninput" Text="Tải về" OnClick="btnTaiVe_Click" />
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <div class="col-6 h-100 pt-2 pb-2">
                <h5 class="tleboxchung">Tệp đã mã hóa</h5>
                <div class="m-0 boder h-100 overflow-auto">
                    <table class="table1 w-100">
                        <tr>
                            <td>Tên tệp:</td>
                            <td>
                                <asp:TextBox ID="txtTenTepDaMaHoa" CssClass="user d-validator-required" Enabled="false" runat="server" Width="242px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <asp:Panel ID="pnZonekythuongTepDaMaHoa" runat="server">
                                <td>Tệp đính kèm</td>
                                <td>
                                    <asp:HiddenField ID="hddFilePathTepDaMaHoa" runat="server" Value="" />
                                    <div id="zonekythuongTepDaMaHoa" style="width: 80%;">
                                        <cc1:AsyncFileUpload ID="AsyncFileUpLoadTepDaMaHoa" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                            ErrorBackColor="Red" ThrobberID="Throbber3" UploadingBackColor="#66CCFF" CssClass="user d-file-upload d-tep-da-ma-hoa" />
                                        <asp:Image ID="Throbber3" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                                    </div>
                                </td>
                            </asp:Panel>
                        </tr>
                        <tr>
                            <td colspan="100" style="padding: 0px">
                                <asp:Panel runat="server" ID="pnThongTinTepDaMaHoa" Visible="True">
                                    <table class="w-100 h-100">
                                        <tr>
                                            <td class="col-2">Người tạo: 
                                            </td>
                                            <td class="col-4">
                                                <asp:TextBox runat="server" ID="lblNguoiTaoTepDaMaHoa" CssClass="user" Enabled="false"></asp:TextBox>
                                            </td>
                                            <td class="col-2">Ngày tạo:
                                            </td>
                                            <td class="col-4">
                                                <asp:TextBox runat="server" ID="lblNgayTaoTepDaMaHoa" CssClass="user" Enabled="false"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="col-2">Người sửa: 
                                            </td>
                                            <td class="col-4">
                                                <asp:TextBox runat="server" ID="lblNguoiSuaTepDaMaHoa" CssClass="user" Enabled="false"></asp:TextBox>
                                            </td>
                                            <td class="col-2">Ngày sửa: 
                                            </td>
                                            <td class="col-4">
                                                <asp:TextBox runat="server" ID="lblNgaySuaTepDaMaHoa" CssClass="user" Enabled="false"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                            </td>
                        </tr>

                        <tr>
                            <td colspan="4">
                                <div>
                                    <asp:Label runat="server" ID="lblThongbaoTepDaMaHoa" ForeColor="Red" CssClass="d-thongbao"></asp:Label>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4">
                                <hr />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4">
                                <div class="w-100 row m-0 p-0">
                                    <asp:Button ID="btnLuuTepDaMaHoa" runat="server" CssClass="col m-0 p-0 mr-1 mt-1 btn buttoninput" Text="Lưu" OnClick="btnLuu_Click" />
                                    <asp:Button ID="btnXemTepDaMaHoa" runat="server" CssClass="col m-0 p-0 mr-1 mt-1 btn buttoninput" Text="Xem" />
                                    <asp:Button ID="btnSuaTepDaMaHoa" runat="server" CssClass="col m-0 p-0 mr-1 mt-1 btn buttoninput" Text="Sửa" OnClick="btnSua_Click" />
                                    <asp:Button ID="btnXoaTepDaMaHoa" runat="server" CssClass="col m-0 p-0 mr-1 mt-1 btn buttoninput" Text="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa tệp này? ');" OnClick="btnXoa_Click" />
                                    <asp:Button ID="btnTaiVeTepDaMaHoa" runat="server" CssClass="col m-0 p-0 mr-1 mt-1 btn buttoninput" Text="Tải về" OnClick="btnTaiVe_Click" />
                                    <asp:Button ID="btnCongBoTepDaMaHoa" runat="server" CssClass="col m-0 p-0 mr-1 mt-1 btn buttoninput" Text="Công bố" OnClientClick="return confirm('Bạn thực sự muốn công bố bản án/quyết định này? ');" OnClick="btnCongBo_Click" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <script
            type="text/javascript"
            id="platform-script"
            data-url="<%= ConfigurationManager.AppSettings["URLMaHoaView"] %>"
            src="../../UI/js/vtccEditor.min.js"></script>
        <script type="text/javascript">
            // init editor
            let vtccEditor = null
            window.addEventListener('VTCC_EDITOR_INITIALIZED', function (e) {
                vtccEditor = e.detail.vtccEditor
            })

            // event open editor
            window.addEventListener('OPEN_EDITOR', (e) => {
                const detail = e?.detail
                vtccEditor.openEditor(detail)
            })

            // event close editor
            window.addEventListener('CLOSE_EDITOR', (e) => {
                vtccEditor.closeEditor({})
            })
            // event saveAsBlob
            window.addEventListener('VTCC_EDITOR_SAVE_BLOB', (e) => {
                const blob = e?.detail?.data.blob
                ////////$("#txtLoaiTep").val( <%=(int)ENUM_LOAI_FILE.FILE_DA_MA_HOA%> + "");
                let file = new File([blob], "da-ma-hoa.docx", { type: "application/vnd.openxmlformats-officedocument.wordprocessingml.document", lastModified: new Date().getTime() });

                let container = new DataTransfer();
                container.items.add(file);
                $('.d-tep-da-ma-hoa div input[type="file"]').prop("files", container.files);
                $("#<%= btnLuuTepDaMaHoa.ClientID %>").click();
                const event = new CustomEvent('CLOSE_EDITOR', {
                    detail: {
                    },
                });
                window.dispatchEvent(event);
            })
        </script>
        <script type="text/javascript">
            $(document).ready(function () {
                $('.add-file').on('click', function () {
                    RunSelectFile();
                });
                function RunSelectFile() {
                    let dropSelect = $('#txtLoaiTep').val();
                    if (dropSelect == null || dropSelect == "") {
                        alert("Bạn hãy chọn loại tệp muốn tải lên");
                        return;
                    }
                    $('.d-file-upload div input[type="file"]').trigger('click');
                }
                $('.file').on('change', function () {
                    var fileName = $(this)[0].files[0].name;
                    $('#file-name').text(fileName);
                });
                $(".dropbtn").on("click", function () {
                    hideAllDropdown();
                    $(this).parent().find('.dropdown-content').addClass('show');
                });
                $.urlParam = function (name) {
                    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
                    if (results == null) {
                        return null;
                    }
                    return decodeURI(results[1]) || 0;
                }

                function SetLoaiFile(loaiFile) {
                    $('.form-check-input').each(function (i, obj) {
                        if ($(obj).val() == loaiFile) {
                            $(obj).attr("checked", "checked");
                        } else {
                            $(obj).removeAttr("checked");
                        }
                    });
                }
                function onSuaFile(loaiFile) {
                    $("#txtLoaiTep").val(loaiFile + "");
                    SetLoaiFile(loaiFile);
                    RunSelectFile();
                }

            })
            $(document).on('change', '.form-check-input', function (event) {
                $('#txtLoaiTep').val($(this).val());
                $('#txtLoaiTep').trigger("change");
            });
            OnInit();
            function OnInit() {
                $('.form-check-input').each(function (i, obj) {
                    if ($(obj).val() == $('#txtLoaiTep').val()) {
                        $(obj).attr("checked", "checked");
                    }
                });
            }
            function onClickLuu() {
                //if ($('.d-file-upload div input[type="file"]').get(0).files.length === 0) {
                //    alert("Hãy chọn file trước khi thực hiện lưu");
                //    return false;
                //}
                return true;
            }
            function DownloadFile(link, fileName) {
                fetch(link)
                    .then(res => res.blob())
                    .then(blob => {
                        var link = document.createElement('a');
                        link.href = window.URL.createObjectURL(blob, {
                            type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
                        });
                        link.download = fileName;
                        link.click();
                    });
            }
            function OnClickMaHoaBanAn(link, troLy) {
                fetch(link)
                    .then(res => res.blob())
                    .then(blob => {
                        blobFile = blob;
                        objTroLy = JSON.parse(troLy);
                        document.querySelector("iframe").addEventListener("load", function (e) {
                            const event = new CustomEvent('OPEN_EDITOR', {
                                detail: {
                                    blob: blob,
                                    headers: {
                                        Authorization: `Bearer ` + objTroLy.AccessToken,
                                        'Device-Uuid': objTroLy.UUID
                                    }
                                },
                            });
                            window.dispatchEvent(event);
                        });
                    });
            }
        </script>
    </form>
</body>
</html>
