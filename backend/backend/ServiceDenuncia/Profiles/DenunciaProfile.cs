using AutoMapper;
using DominioDenuncia;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ServiceDenuncia;


namespace ServiceDenuncia.Profiles
{
    public class DenunciaProfile : Profile
    {
        public DenunciaProfile()
        {
            // Entidade Imagen -> DenunciaMediaDto
            CreateMap<Imagen, DenunciaMediaDto>()
                .ForMember(d => d.Id, opt => opt.MapFrom(s => s.Id))
                .ForMember(d => d.Url, opt => opt.MapFrom(s => s.Url))
                .ForMember(d => d.NomeArquivo, opt => opt.MapFrom(s => s.NomeArquivo))
                .ForMember(d => d.ContentType, opt => opt.MapFrom(s => s.ContentType))
                .ForMember(d => d.TamanhoBytes, opt => opt.MapFrom(s => s.TamanhoBytes))
                .ForMember(d => d.Largura, opt => opt.MapFrom(s => s.Largura))
                .ForMember(d => d.Altura, opt => opt.MapFrom(s => s.Altura));


            // Entidade Video -> DenunciaMediaDto
            CreateMap<Video, DenunciaMediaDto>()
                .ForMember(d => d.Id, opt => opt.MapFrom(s => s.Id))
                .ForMember(d => d.Url, opt => opt.MapFrom(s => s.Url))
                .ForMember(d => d.NomeArquivo, opt => opt.MapFrom(s => s.NomeArquivo))
                .ForMember(d => d.ContentType, opt => opt.MapFrom(s => s.ContentType))
                .ForMember(d => d.TamanhoBytes, opt => opt.MapFrom(s => s.TamanhoBytes))
                .ForMember(d => d.Largura, opt => opt.MapFrom(s => s.Largura))
                .ForMember(d => d.Altura, opt => opt.MapFrom(s => s.Altura))
                .ForMember(d => d.DuracaoSegundos, opt => opt.MapFrom(s => s.DuracaoSegundos))
                .ForMember(d => d.ThumbnailUrl, opt => opt.MapFrom(s => s.ThumbnailUrl));


            // Denuncia -> DenunciaDto (mapeia coleções de Midia)
            CreateMap<Denuncia, DenunciaDto>()
                .ForMember(d => d.Id, opt => opt.MapFrom(s => s.Id))
                .ForMember(d => d.Titulo, opt => opt.MapFrom(s => s.Titulo))
                .ForMember(d => d.Descricao, opt => opt.MapFrom(s => s.Descricao))
                .ForMember(d => d.UsuarioId, opt => opt.MapFrom(s => s.UsuarioId))
                .ForMember(d => d.EmailContato, opt => opt.MapFrom(s => s.EmailContato))
                .ForMember(d => d.TelefoneContato, opt => opt.MapFrom(s => s.TelefoneContato))
                .ForMember(d => d.Latitude, opt => opt.MapFrom(s => s.Latitude))
                .ForMember(d => d.Longitude, opt => opt.MapFrom(s => s.Longitude))
                .ForMember(d => d.Sensitive, opt => opt.MapFrom(s => s.Sensitive))
                // converte enum para string
                .ForMember(d => d.Status, opt => opt.MapFrom(s => s.Status.ToString()))
                .ForMember(d => d.CriadoEm, opt => opt.MapFrom(s => s.CriadoEm))
                .ForMember(d => d.AtualizadoEm, opt => opt.MapFrom(s => s.AtualizadoEm))
                // coleções: Imagens e Videos mapeadas automaticamente para DenunciaMediaDto
                .ForMember(d => d.Imagens, opt => opt.MapFrom(s => s.Imagens ?? Enumerable.Empty<Imagen>()))
                .ForMember(d => d.Videos, opt => opt.MapFrom(s => s.Videos ?? Enumerable.Empty<Video>()));
                
        }
    }
}
