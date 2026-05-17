<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MaHoaBanAn.aspx.cs" Inherits="WEB.GSTP.QLAN.MaHoaBanAn" Async="true" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%--<%@ Register Assembly="DevExpress.Web.v18.2, Version=18.2.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>--%>
<%@ Import Namespace="WEB.GSTP.QLAN" %>
<%@ Import Namespace="Module.Common" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
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

        .tleboxchung {
            margin-top: 5px;
        }

        .pl-3 {
            padding-left: 10px;
        }
    </style>
</head>
<body style="width: auto; height: auto; min-height: 200px; min-width: 500px">
    <form id="form1" runat="server" enctype="multipart/form-data">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="box" style="padding-bottom: 10px">
            <div class="form_tt">
                <div class="boxchung">
                    <h5 class="tleboxchung">Đính kèm BA/QĐ</h5>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <asp:TextBox ID="txtTepID" runat="server" Visible="false" />
                            <tr>
                                <td class="col-2">Loại tệp:</td>
                                <td class="col-7">
                                    <asp:RadioButtonList ID="rdbLoaiTep" runat="server" RepeatDirection="Horizontal" Font-Bold="false" AutoPostBack="false">
                                    </asp:RadioButtonList>
                                </td>
                                <td class="col-3"></td>
                            </tr>
                            <asp:Panel runat="server" ID="pnTenTep" Visible="False">
                                <tr>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td class="col-2">Tên tệp:</td>
                                    <td class="col-7">
                                        <asp:TextBox ID="txtTenTep" CssClass="user d-validator-required" Enabled="true" runat="server" Width="242px"></asp:TextBox>
                                    </td>
                                    <td class="col-3"></td>
                                </tr>
                            </asp:Panel>
                            <tr>
                                <asp:Panel ID="pnZonekythuong" runat="server">
                                    <td class="col-2">Tệp đính kèm</td>
                                    <td colspan="3">

                                        <asp:HiddenField ID="hddFilePath" runat="server" Value="" />
                                        <div id="zonekythuong" style="margin-top: 10px; width: 80%;">
                                            <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                                ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" CssClass="user d-file-upload" />
                                            <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                                        </div>
                                    </td>
                                </asp:Panel>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <lable id="file-name"></lable>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4" align="center">
                                    <div>
                                        <asp:Label runat="server" ID="lblThongbao" ForeColor="Red" CssClass="d-thongbao"></asp:Label>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div>
                    <table style="width: 100%; padding-top: 15px;">
                        <tr>
                            <td style="width: 100%" class="pt-3 d-flex justify-content-center">
                                <div class="pr-2">
                                    <asp:Button ID="btnLuu" runat="server" CssClass="btn buttoninput d-btn-luu" Text="Lưu Tệp" OnClientClick="return onClickLuu();" OnClick="btnLuu_Click" />
                                </div>
                                <div class="pr-2">
                                    <asp:Button ID="btnLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                                </div>
                                <div class="pr-2">
                                    <asp:Button ID="btnCongBo" UseSubmitBehavior="false" runat="server" CssClass="btn buttoninput" OnClientClick="if (!confirm('Xác nhận công bố bản án? ')) return false;" Text="Công bố" OnClick="btnCongBo_Click" />
                                </div>
                                <asp:UpdatePanel ID="UpdatePanel3" runat="server" UpdateMode="Conditional" defaultbutton="btnDisableEnter">
                                    <ContentTemplate>
                                        <asp:Button ID="btnDong" UseSubmitBehavior="false" runat="server" CssClass="buttoninput" Text="Đóng" OnClientClick="window.close()" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>

                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <table class="table1">
            <tr>
                <td>
                    <asp:Label runat="server" ID="Label1" ForeColor="Red"></asp:Label>
                    <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4" PageSize="10" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages" CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                        ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                        <Columns>
                            <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                            <asp:BoundColumn DataField="LOAIFILE" Visible="false"></asp:BoundColumn>

                            <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                <HeaderTemplate>TT</HeaderTemplate>
                                <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="200px" ItemStyle-HorizontalAlign="Left">
                                <HeaderTemplate>Tên tệp</HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("TENFILE")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:BoundColumn DataField="NGUOITAO" HeaderText="Người tạo" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>
                            <asp:BoundColumn DataField="NGAYTAO" HeaderText="Ngày tạo" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>
                            <asp:BoundColumn DataField="NGUOISUA" HeaderText="Người sửa" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>
                            <asp:BoundColumn DataField="NGAYSUA" HeaderText="Ngày sửa" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm:ss}"></asp:BoundColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="100px" ItemStyle-HorizontalAlign="Left">
                                <HeaderTemplate>Loại tệp</HeaderTemplate>
                                <ItemTemplate>
                                    <%--<asp:Label Height="30px" Visible="true" runat="server" Text=""></asp:Label>--%>
                                    <%#Eval("LoaiFileText")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                <HeaderTemplate>Thao tác</HeaderTemplate>
                                <ItemStyle Height="40px" />
                                <ItemTemplate>
                                    <asp:LinkButton ID="lblXem" runat="server" Text="Xem" CausesValidation="false" CommandName="Xem" ForeColor="#0e7eee"
                                        CommandArgument='<%#Eval("ID") %>' CssClass="pl-3"></asp:LinkButton>
                                    <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                        CommandArgument='<%#Eval("ID") %>' CssClass="pl-3"></asp:LinkButton>
                                    <asp:LinkButton ID="lblDownload" runat="server" Text="Tải về" CausesValidation="false" ForeColor="#0e7eee" CommandName="Download"
                                        CommandArgument='<%#Eval("ID") %>' CssClass="pl-3" OnClientClick='<%# "onClickTaiVe(" +Eval("ID") + " );" %>'></asp:LinkButton>
                                    <asp:LinkButton ID="lblXoa" runat="server" Text="Xóa" CausesValidation="false" CommandName="Xoa" ForeColor="#0e7eee"
                                        CommandArgument='<%#Eval("ID") %>' CssClass="pl-3" OnClientClick="return confirm('Bạn thực sự muốn xóa tệp này? ');"></asp:LinkButton>
                                    <asp:LinkButton ID="lblMaHoa" runat="server" Text="Mã hóa" CausesValidation="false" CommandName="MaHoa" ForeColor="#0e7eee"
                                        CommandArgument='<%#Eval("ID") %>' CssClass="pl-3"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                        </Columns>
                        <HeaderStyle CssClass="header"></HeaderStyle>
                        <ItemStyle CssClass="chan"></ItemStyle>
                        <PagerStyle Visible="false"></PagerStyle>
                    </asp:DataGrid>
                </td>
            </tr>
        </table>

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
                $('.d-file-upload div input[type="file"]').prop("files", container.files);
                $('#<%=rdbLoaiTep.ClientID %>').find(`input[value='${<%=(int)ENUM_LOAI_FILE.FILE_DA_MA_HOA%>}']`).prop("checked", true);
                $('#btnLuu').click();
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
